import 'package:app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

class WebRTCService {
  final rtc.RTCVideoRenderer localRenderer = rtc.RTCVideoRenderer();

  final rtc.RTCVideoRenderer remoteRenderer = rtc.RTCVideoRenderer();

  rtc.MediaStream? _localStream;

  rtc.RTCPeerConnection? peerConnection;

  Function(rtc.RTCIceCandidate)? onIceCandidate;

  bool remoteTrackReceived = false;

  Function(String)? onDebug;

  VoidCallback? onRemoteStream;
  Future<void> initializeViewer() async {
    await remoteRenderer.initialize();
  }

  Future<void> initializeCamera() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _localStream = await rtc.navigator.mediaDevices.getUserMedia({
      "audio": false,
      "video": {"facingMode": "environment"},
    });

    localRenderer.srcObject = _localStream;
  }

  Future<void> createPeerConnection({bool isStreamer = false}) async {
    peerConnection = await rtc.createPeerConnection({
      "iceServers": [
        {
          "urls": ["stun:stun.l.google.com:19302"],
        },
      ],
    });
    if (!isStreamer) {
      await peerConnection!.addTransceiver(
        kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: rtc.RTCRtpTransceiverInit(
          direction: rtc.TransceiverDirection.RecvOnly,
        ),
      );
    }
    peerConnection!.onIceCandidate = (candidate) {
      print("ICE Candidate: ${candidate.candidate}");

      onIceCandidate?.call(candidate);
    };

    peerConnection!.onIceConnectionState = (state) {
      onDebug?.call("ICE State: $state");
    };

    peerConnection!.onConnectionState = (state) {
      onDebug?.call("Connection State: $state");
    };

    peerConnection!.onTrack = (event) {
      onDebug?.call("Remote Track Added");

      onDebug?.call("Streams count: ${event.streams.length}");

      if (event.streams.isNotEmpty) {
        final stream = event.streams.first;

        onDebug?.call("Video tracks: ${stream.getVideoTracks().length}");

        remoteRenderer.srcObject = stream;
        onRemoteStream?.call();

        onDebug?.call("Renderer attached");
      }
    };

    if (isStreamer && _localStream != null) {
      for (final track in _localStream!.getTracks()) {
        await peerConnection!.addTrack(track, _localStream!);
      }
    }
    onDebug?.call("Peer Connection Created");
  }

  Future<rtc.RTCSessionDescription> createOffer() async {
    final offer = await peerConnection!.createOffer();

    await peerConnection!.setLocalDescription(offer);

    onDebug?.call("Offer Created");

    onDebug?.call("Offer SDP Generated");
    return offer;
  }

  Future<void> switchCamera() async {
    final videoTracks = _localStream?.getVideoTracks();

    if (videoTracks == null || videoTracks.isEmpty) {
      return;
    }

    rtc.Helper.switchCamera(videoTracks.first);
  }

  Future<void> setRemoteDescription(
    rtc.RTCSessionDescription description,
  ) async {
    await peerConnection!.setRemoteDescription(description);
    onDebug?.call("Remote Description Set (${description.type})");
  }

  Future<rtc.RTCSessionDescription> createAnswer() async {
    final answer = await peerConnection!.createAnswer();

    await peerConnection!.setLocalDescription(answer);

    onDebug?.call("Answer Created");
    return answer;
  }

  Future<void> addIceCandidate(rtc.RTCIceCandidate candidate) async {
    onDebug?.call("Adding ICE Candidate");
    await peerConnection!.addCandidate(candidate);
    onDebug?.call("ICE Candidate Added");
  }

  Future<void> dispose() async {
    localRenderer.dispose();
    remoteRenderer.dispose();

    await _localStream?.dispose();

    await peerConnection?.close();

    peerConnection = null;
    _localStream = null;
  }

  Future<void> printStats() async {
    final stats = await peerConnection?.getStats();

    stats?.forEach((report) {
      print(report.values);
    });
  }
}
