import '../services/socket_service.dart';
import '../services/webrtc_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class PortalController {
  final SocketService socketService;
  final WebRTCService webrtcService;
  String? currentPeerId;

  PortalController({required this.socketService, required this.webrtcService});

  void initialize() {
    final socket = socketService.socket;

    if (socket == null) return;

    webrtcService.onIceCandidate = (candidate) {
      if (currentPeerId == null) return;

      socketService.sendIceCandidate(
        targetId: currentPeerId!,
        candidate: {
          "candidate": candidate.candidate,
          "sdpMid": candidate.sdpMid,
          "sdpMLineIndex": candidate.sdpMLineIndex,
        },
      );
    };
    webrtcService.onDebug = (message) {
      socketService.sendDebug(message);
    };
    socket.on("viewer-joined", (data) async {
      final viewerId = data["viewerId"];
      currentPeerId = viewerId;

      socketService.sendDebug("Creating offer for $viewerId");

      final offer = await webrtcService.createOffer();

      socketService.sendOffer(
        targetId: viewerId,
        offer: {"sdp": offer.sdp, "type": offer.type},
      );
    });

    socket.on("offer", (data) async {
      socketService.sendDebug("Offer Received");
      final offer = RTCSessionDescription(
        data["offer"]["sdp"],
        data["offer"]["type"],
      );

      await webrtcService.setRemoteDescription(offer);
      currentPeerId = data["senderId"];
      final answer = await webrtcService.createAnswer();

      socketService.sendAnswer(
        targetId: data["senderId"],
        answer: {"sdp": answer.sdp, "type": answer.type},
      );
    });

    socket.on("answer", (data) async {
      socketService.sendDebug("Answer Received");

      final answer = RTCSessionDescription(
        data["answer"]["sdp"],
        data["answer"]["type"],
      );

      await webrtcService.setRemoteDescription(answer);
    });

    socket.on("ice-candidate", (data) async {
      socketService.sendDebug("ICE Candidate Received");

      final candidate = RTCIceCandidate(
        data["candidate"]["candidate"],
        data["candidate"]["sdpMid"],
        data["candidate"]["sdpMLineIndex"],
      );

      await webrtcService.addIceCandidate(candidate);
    });
  }
}
