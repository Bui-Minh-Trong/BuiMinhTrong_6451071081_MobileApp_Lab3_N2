import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF130160),
          primary: const Color(0xFF130160),
          secondary: const Color(0xFFFF9228),
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const ProfileScreen(),
    );
  }
}
