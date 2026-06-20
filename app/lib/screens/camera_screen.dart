import 'package:flutter/material.dart';

import '../services/webrtc_service.dart';
import '../controllers/portal_controller.dart';
import '../services/socket_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final WebRTCService webrtc = WebRTCService();

  final SocketService socketService = SocketService();

  late final PortalController portalController;

  bool initialized = false;

  bool streaming = false;

  String cameraId = "PORTAL-001";

  String cameraName = "Rear Camera";

  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future<void> initialize() async {
    await webrtc.initializeCamera();

    await webrtc.createPeerConnection(isStreamer: true);

    await socketService.connect();

    portalController = PortalController(
      socketService: socketService,
      webrtcService: webrtc,
    );

    portalController.initialize();

    await Future.delayed(const Duration(seconds: 1));

    socketService.registerCamera(cameraId);

    setState(() {
      initialized = true;
      streaming = true;
    });
  }

  Future<void> switchCamera() async {
    await webrtc.switchCamera();

    setState(() {
      cameraName = cameraName == "Rear Camera" ? "Front Camera" : "Rear Camera";
    });
  }

  Future<void> stopStream() async {
    await webrtc.dispose();

    setState(() {
      streaming = false;
    });
  }

  @override
  void dispose() {
    socketService.dispose();
    webrtc.dispose();

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
      appBar: AppBar(title: const Text("Portal Camera"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: streaming ? Colors.green : Colors.red,
                  size: 14,
                ),

                const SizedBox(width: 8),

                Text(
                  streaming ? "ONLINE" : "OFFLINE",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text("CAMERA ID", style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 8),

            Text(
              cameraId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            const Text("STATUS", style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 8),

            Text(
              streaming ? "Streaming" : "Stopped",
              style: TextStyle(
                color: streaming ? Colors.green : Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            const Text("CAMERA", style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 8),

            Text(
              cameraName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: switchCamera,
                icon: const Icon(Icons.cameraswitch),
                label: const Text("Switch Camera"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: stopStream,
                icon: const Icon(Icons.stop),
                label: const Text("Stop Stream"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
