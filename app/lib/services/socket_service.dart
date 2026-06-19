import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket?.connected == true) return;

    _socket = io.io(
      "http://192.168.0.170:5000",
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _registerListeners();

    _socket!.connect();
  }

  void _registerListeners() {
    _socket!.onConnect((_) {
      print("Connected");
    });

    _socket!.onDisconnect((_) {
      print("Disconnected");
    });

    _socket!.onConnectError((error) {
      print("Connect Error: $error");
    });

    _socket!.onError((error) {
      print("Socket Error: $error");
    });

    _socket!.on("camera-registered", (data) {
      print("Camera Registered: ${data["cameraId"]}");
    });

    _socket!.on("camera-not-found", (_) {
      print("Camera Not Found");
    });

    _socket!.on("joined-camera", (data) {
      print("Joined Camera: ${data["cameraId"]}");
    });

    _socket!.on("viewer-joined", (data) {
      print("Viewer Joined: ${data["viewerId"]}");
    });

    _socket!.on("stream-offline", (_) {
      print("Stream Offline");
    });
  }

  void registerCamera(String cameraId) {
    _socket?.emit("register-camera", {"cameraId": cameraId});
  }

  void joinCamera(String cameraId) {
    _socket?.emit("join-camera", {"cameraId": cameraId});
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }

  void sendOffer({required String targetId, required dynamic offer}) {
    _socket?.emit("offer", {"targetId": targetId, "offer": offer});
  }

  void sendAnswer({required String targetId, required dynamic answer}) {
    _socket?.emit("answer", {"targetId": targetId, "answer": answer});
  }

  void sendIceCandidate({
    required String targetId,
    required dynamic candidate,
  }) {
    _socket?.emit("ice-candidate", {
      "targetId": targetId,
      "candidate": candidate,
    });
  }

  void sendDebug(String message) {
    _socket?.emit("debug", {"message": message});
  }
}
