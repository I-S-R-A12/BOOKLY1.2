import 'package:flutter/material.dart';
import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Simulación de libros con todos los datos necesarios
 // final List<Map<String, String>> books = [
/*
    
    {
      'title': 'Grupo Escolar',
      'author': 'Autor Desconocido',
      'year': '2020',
      'user': 'Juan Pérez',
      'imagePath': 'assets/images/book1.jpg',
    },
    {
      'title': 'RONALDO',
      'author': 'Biografía',
      'year': '2018',
      'user': 'Maria López',
      'imagePath': 'assets/images/book2.jpg',
    },
    // ... más libros

  ];
*/
  void _showBookInfo(BuildContext context, Map<String, String> book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📖 ${book['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(book['imagePath']!, height: 100),
            const SizedBox(height: 10),
            Text('Autor: ${book['author']}'),
            Text('Publicado: ${book['year']}'),
            Text('Publicado por: ${book['user']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKLY'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
         /* Padding(                        //para la imagen del grupo solo que no tengo un link
  padding: const EdgeInsets.all(16.0),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.network(
      'https://ejemplo.com/mi-banner.jpg',
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  ),
),
*/
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📚 Banner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Descubre nuevos libros y comparte tus favoritos',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('libros').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay libros disponibles"));
        }

        final libros = snapshot.data!.docs;
        //final bookData = book.data() as Map<String, dynamic>;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: libros.length,

          itemBuilder: (context, index) {
  final book = libros[index];
  final bookData = book.data() as Map<String, dynamic>;

  return GestureDetector(
    onTap: () {
      _showBookInfo(context, {
        'title': bookData['title'],
        'author': bookData['author'],
        'year': bookData['year'],
        'user': bookData['user'],
        'imagePath': bookData['imagePath'],
      });
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              bookData['imagePath'],
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              bookData['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              bookData['author'],
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
        );
      },
    ),
  ),
),

        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addBook",
            onPressed: () {
              // TODO: navegación a la vista de nuevo libro
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  VistaPerfil()),
              );
            },
            child: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
