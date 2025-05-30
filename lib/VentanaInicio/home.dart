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
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpww0Cs36tkHB49yJqMDpPuPtzACniVldEtg&s',
                  bookName: 'El Principito',
                  publishDate: '1943',
                  author: 'Antoine de Saint-Exupéry',
                  postedBy: 'Martin y Tati',
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
