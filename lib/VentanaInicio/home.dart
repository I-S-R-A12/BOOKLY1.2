import 'package:flutter/material.dart';
import 'detalle_libro.dart';
import 'package:bookly12/vistaPerfil/vistaPerfil.dart';

import 'package:bookly12/Ventana-Presentar/publicar_libro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> librosEjemplo = [
    {
      'title': '1984',
      'author': 'George Orwell',
      'year': '1949',
      'user': 'admin',
      'imagePath': 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
    },
    {
      'title': 'Cien Años de Soledad',
      'author': 'Gabriel García Márquez',
      'year': '1967',
      'user': 'admin',
      'imagePath':
          'https://th.bing.com/th/id/R.f9857b084f6f5a6237f9d0ecfca4b670?rik=imDOrYrkU04CSg&pid=ImgRaw&r=0',
    },
    {
      'title': 'El Principito',
      'author': 'Antoine de Saint-Exupéry',
      'year': '1943',
      'user': 'admin',
      'imagePath':
          'https://www.pixartprinting.it/blog/wp-content/uploads/2024/03/1-2.jpg',
    },
    {
      'title': 'Don Quijote',
      'author': 'Miguel de Cervantes',
      'year': '1605',
      'user': 'admin',
      'imagePath':
          'https://th.bing.com/th/id/R.acb849d06a03277e09910511f3f0f157?rik=jieXhOSaEagD1Q&riu=http%3a%2f%2f3.bp.blogspot.com%2f-9qnowouOH7A%2fUbD8EiJifgI%2fAAAAAAAACFk%2fmLfuFCvp5qM%2fs1600%2fdon-quijote-de-la-mancha-cervantes-edic-anaconda_MLA-F-139991622_1763.jpg&ehk=wb9LrXC9LYGJMFSNIHiokUyTIecqn6w4GPlZ0tryRWw%3d&risl=&pid=ImgRaw&r=0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1E3DD),

      //  Título de la app
      appBar: AppBar(
        title: const Text('BOOKLY'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: CustomScrollView(
        slivers: [
          // 🔹 Banner que desaparece al hacer scroll
          SliverAppBar(
            expandedHeight: 350,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Lista de libros
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final book = librosEjemplo[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetalleLibro(
                              titulo: book['title']!,
                              autor: book['author']!,
                              anio: book['year']!,
                              usuario: book['user']!,
                              imagen: book['imagePath']!,
                            ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(book['imagePath']!, fit: BoxFit.cover),
                  ),
                );
              }, childCount: librosEjemplo.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio:
                    0.48, // Reducido para que las imágenes sean más pequeñas
              ),
            ),
          ),
        ],
      ),

      // 🔹 Botones inferiores
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Aquí puedes activar los botones cuando estén listos
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LibrosForm()),
                );
              },
              tooltip: 'Agregar libro',
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, size: 32),
              tooltip: 'Perfil',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => vistaPerfil()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




/*


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKLY'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => vistaPerfil())
              );
            },
          ),
    
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: libros.length,
              itemBuilder: (context, index) {
                final book = libros[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleLibro(
                          titulo: book['title'],
                          autor: book['author'],
                          anio: book['year'],
                          usuario: book['user'],
                          imagen: book['imagePath'],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book['imagePath'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
*/