import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PortalApp());
}

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portal',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
