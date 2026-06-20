import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../controllers/portal_controller.dart';
import '../services/socket_service.dart';
import '../services/webrtc_service.dart';

class ViewerScreen extends StatefulWidget {
  const ViewerScreen({super.key});

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  final TextEditingController cameraIdController = TextEditingController(
    text: "PORTAL-001",
  );

  final SocketService socketService = SocketService();

  final WebRTCService webrtc = WebRTCService();

  late final PortalController portalController;

  bool initialized = false;
  bool connected = false;

  @override
  void initState() {
    super.initState();

    webrtc.onRemoteStream = () {
      if (mounted) {
        setState(() {});
      }
    };

    initialize();
  }

  Future<void> initialize() async {
    await webrtc.initializeViewer();

    await webrtc.createPeerConnection(isStreamer: false);

    await socketService.connect();

    portalController = PortalController(
      socketService: socketService,
      webrtcService: webrtc,
    );

    portalController.initialize();

    setState(() {
      initialized = true;
    });
  }

  Future<void> connectToCamera() async {
    socketService.joinCamera(cameraIdController.text.trim());

    setState(() {
      connected = true;
    });
  }

  void disconnectViewer() {
    setState(() {
      connected = false;
    });
  }

  @override
  void dispose() {
    socketService.dispose();
    webrtc.dispose();
    cameraIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Portal Viewer")),
      body: connected
          ? Stack(
              children: [
                Positioned.fill(
                  child: RTCVideoView(
                    webrtc.remoteRenderer,
                    mirror: false,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: webrtc.remoteTrackReceived
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          webrtc.remoteTrackReceived ? "LIVE" : "CONNECTING",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      cameraIdController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black87,
                    onPressed: disconnectViewer,
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.videocam_rounded,
                        size: 90,
                        color: Colors.white70,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Portal Viewer",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Watch your remote camera from anywhere",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),

                      const SizedBox(height: 40),

                      TextField(
                        controller: cameraIdController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Camera ID",
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: connectToCamera,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Watch Stream"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
