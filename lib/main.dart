import 'package:flutter/material.dart';
import 'Ventana-Presentar/publicar_libro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: publicar_libro(),
        ),
      ),
    );
  }
}
