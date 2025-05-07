import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class GuestScreen extends StatefulWidget {
  final String clubId;

  const GuestScreen({super.key, required this.clubId});

  @override
  _GuestScreenState createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late RTCPeerConnection peerConnection;
  String? callId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _joinCall();
  }

  Future<void> _joinCall() async {
    // Verify the user is an alumni or mentor
    final userDoc = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    final userRole = userDoc.data()!['role'] as String;
    if (userRole != 'alumni' && userRole != 'mentor') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only alumni or mentors can join as a guest.')),
      );
      Navigator.pop(context);
      return;
    }

    // Find the active livestream for the club
    final livestreamsSnapshot = await _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (livestreamsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active livestream found.')),
      );
      Navigator.pop(context);
      return;
    }

    callId = livestreamsSnapshot.docs.first.id;

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}],
    });

    final callDoc = await _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .get();
    final offer = RTCSessionDescription(
      callDoc['offer']['sdp'],
      callDoc['offer']['type'],
    );

    await peerConnection.setRemoteDescription(offer);
    final localStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
    localStream.getTracks().forEach((track) => peerConnection.addTrack(track, localStream));
    localRenderer.srcObject = localStream;

    final answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    await _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .update({
      'answer': {'sdp': answer.sdp, 'type': answer.type},
      'guestId': _auth.currentUser?.uid,
    });

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      _firestore
          .collection('clubs')
          .doc(widget.clubId)
          .collection('livestreams')
          .doc(callId)
          .collection('candidates')
          .doc('guest')
          .collection('candidates')
          .add(candidate.toMap());
    };

    // Listen for Host's ICE candidates
    _firestore
        .collection('clubs')
        .doc(widget.clubId)
        .collection('livestreams')
        .doc(callId)
        .collection('candidates')
        .doc('host')
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

    // Display Host's video
    peerConnection.onTrack = (event) {
      remoteRenderer.srcObject = event.streams[0];
    };

    setState(() {});
  }

  Future<void> _endCall() async {
    localRenderer.srcObject?.getTracks().forEach((track) => track.stop());
    await peerConnection.close();
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
        title: const Text('Guest Livestream'),
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
            child: const Text('Leave Livestream'),
          ),
        ],
      ),
    );
  }
}