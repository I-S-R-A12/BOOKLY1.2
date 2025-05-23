import 'package:flutter/material.dart';
import 'verpost.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostScreen(
        imagePath:
            'https://upload.wikimedia.org/wikipedia/en/0/05/Littleprince.JPG',
        bookName: 'El Principito',
        publishDate: '1943',
        author: 'Antoine de Saint-Exupéry',
        postedBy: 'Admin',
      ),
    );
  }
}
