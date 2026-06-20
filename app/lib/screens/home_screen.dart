import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'camera_screen.dart';
import 'viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController serverController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadServerUrl();
  }

  Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();

    serverController.text =
        prefs.getString("server_url") ?? "http://192.168.0.170:5000";
  }

  Future<void> saveServerUrl() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("server_url", serverController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Server URL Saved")));
  }

  @override
  void dispose() {
    serverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.videocam, size: 80, color: Colors.white),

                  const SizedBox(height: 24),

                  const Text(
                    "PORTAL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: serverController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Server URL",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: saveServerUrl,
                      child: const Text("Save Server URL"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CameraScreen(),
                          ),
                        );
                      },
                      child: const Text("Camera Mode"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewerScreen(),
                          ),
                        );
                      },
                      child: const Text("Viewer Mode"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
