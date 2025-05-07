import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ViewerScreen extends StatefulWidget {
  final String clubId;

  const ViewerScreen({super.key, required this.clubId});

  @override
  _ViewerScreenState createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late RTCPeerConnection viewerConnection;
  String? callId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _watchCall();
  }

  Future<void> _watchCall() async {
    // Verify the user is a club member
    final clubDoc = await _firestore.collection('clubs').doc(widget.clubId).get();
    final members = List<String>.from(clubDoc.data()!['memebers'] ?? []);
    if (!members.contains(_auth.currentUser?.uid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only club members can watch the livestream.')),
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

    await remoteRenderer.initialize();

    viewerConnection = await createPeerConnection({
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

    await viewerConnection.setRemoteDescription(offer);
    viewerConnection.onTrack = (event) {
      remoteRenderer.srcObject = event.streams[0];
    };

    // Listen for Host’s ICE candidates
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
              viewerConnection.addCandidate(RTCIceCandidate(
                change.doc['candidate'],
                change.doc['sdpMid'],
                change.doc['sdpMLineIndex'],
              ));
            }
          });
        });

    setState(() {});
  }

  Future<void> _endWatching() async {
    await viewerConnection.close();
    remoteRenderer.dispose();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Livestream'),
        backgroundColor: const Color(0xFF4A7A72),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(remoteRenderer),
          ),
          ElevatedButton(
            onPressed: _endWatching,
            child: const Text('Stop Watching'),
          ),
        ],
      ),
    );
  }
}