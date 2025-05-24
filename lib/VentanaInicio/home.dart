import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle_libro.dart';
//import 'agregar_libro.dart'; // pantalla agregar libro

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
                MaterialPageRoute(builder: (context) => VistaPerfil()),
              );
            },
          ),
         /* IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar libro',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const publicar_libro()),
              );
            },
          ),*/
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






/*import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle_libro.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),     // la vista de publicados los libros 
   // publicar_libro(),   //  la vista para agregar libro
    VistaPerfil(),        // Vista del perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

//class _HomeState extends State<Home> 
//{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKLY'),
        backgroundColor: Colors.blueAccent,
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
