import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class HostScreen extends StatefulWidget {
  final String clubId;

  const HostScreen({super.key, required this.clubId});

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late RTCPeerConnection peerConnection;
  MediaStream? localStream;
  String? callId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initHost();
  }

  Future<void> _initHost() async {
    // Verify the user is the clubManager
    final clubDoc = await _firestore.collection('clubs').doc(widget.clubId).get();
    if (clubDoc.data()!['ClubManager'] != _auth.currentUser?.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only the club manager can start a livestream.')),
      );
      Navigator.pop(context);
      return;
    }

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}],
    });

    localStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
    localStream!.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream!);
    });

    localRenderer.srcObject = localStream;

    // Generate SDP offer
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    callId = 'call_${widget.clubId}_${DateTime.now().millisecondsSinceEpoch}';
    await _firestore.collection('clubs').doc(widget.clubId).collection('livestreams').doc(callId).set({
      'offer': {'sdp': offer.sdp, 'type': offer.type},
      'hostId': _auth.currentUser?.uid,
      'status': 'active',
    });

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      _firestore
          .collection('clubs')
          .doc(widget.clubId)
          .collection('livestreams')
          .doc(callId)
          .collection('candidates')
          .doc('host')
          .collection('candidates')
          .add(candidate.toMap());
    };

    // Listen for Guest's answer
    _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists && snapshot.data()!['answer'] != null) {
            final answer = RTCSessionDescription(
              snapshot.data()!['answer']['sdp'],
              snapshot.data()!['answer']['type'],
            );
            peerConnection.setRemoteDescription(answer);
          }
        });

    // Listen for Guest's ICE candidates
    _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .collection('candidates')
        .doc('guest')
        .collection('candidates')
        .snapshots()
        .listen((snapshot) {
          snapshot.docChanges.forEach((change) {
            if (change.type == DocumentChangeType.added) {
              peerConnection.addCandidate(RTCIceCandidate(
                change.doc['candidate'],
                change.doc['sdpMid'],
                change.doc['sdpMLineIndex'],
              ));
            }
          });
        });

    // Display Guest's video
    peerConnection.onTrack = (event) {
      remoteRenderer.srcObject = event.streams[0];
    };

    setState(() {});
  }

  Future<void> _endCall() async {
    localStream?.getTracks().forEach((track) => track.stop());
    await peerConnection.close();
    await _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .delete();
    localRenderer.dispose();
    remoteRenderer.dispose();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Livestream'),
        backgroundColor: const Color(0xFF4A7A72),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(localRenderer),
          ),
          Expanded(
            child: RTCVideoView(remoteRenderer),
          ),
          ElevatedButton(
            onPressed: _endCall,
            child: const Text('End Livestream'),
          ),
        ],
      ),
    );
  }
}