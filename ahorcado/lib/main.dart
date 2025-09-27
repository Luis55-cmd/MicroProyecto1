import 'package:ahorcado/widget1/widget1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Ahorcado1(),
      debugShowCheckedModeBanner: false,
    );
  }
}
