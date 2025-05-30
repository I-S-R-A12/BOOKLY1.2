import 'package:flutter/material.dart';
import 'package:bookly12/verpost.dart'; // Asegúrate que la ruta sea correcta

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenido")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PostScreen(
                  imagePath:
                      'https://upload.wikimedia.org/wikipedia/en/8/8e/Chainsaw_Man_volume_1.png',
                  bookName: 'Chainsaw Man',
                  publishDate: '2020-01-01',
                  author: 'Tatsuki Fujimoto',
                  postedBy: 'MartinTax',
                ),
              ),
            );
          },
          child: const Text("Ver publicación"),
        ),
      ),
    );
  }
}
