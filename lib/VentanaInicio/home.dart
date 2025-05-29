/*import 'package:flutter/material.dart';
import 'detalle_libro.dart';
import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:bookly12/Ventana-Presentar/publicar_libro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle_libro.dart';

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
      'imagePath': 'https://covers.openlibrary.org/b/id/10202163-L.jpg',
    },
    {
      'title': 'El Principito',
      'author': 'Antoine de Saint-Exupéry',
      'year': '1943',
      'user': 'admin',
      'imagePath': 'https://covers.openlibrary.org/b/id/11153245-L.jpg',
    },
    {
      'title': 'Don Quijote',
      'author': 'Miguel de Cervantes',
      'year': '1605',
      'user': 'admin',
      'imagePath': 'https://covers.openlibrary.org/b/id/10472286-L.jpg',
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
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = librosEjemplo[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleLibro(
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
                      child: Image.network(
                        book['imagePath']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                childCount: librosEjemplo.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.48, // Reducido para que las imágenes sean más pequeñas
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
                MaterialPageRoute(builder: (context) => LibrosForm())
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
                MaterialPageRoute(builder: (context) => vistaPerfil())
              );
            },
            ),
            
          ],
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'detalle_libro.dart';
import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:bookly12/Ventana-Presentar/publicar_libro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> librosFromFirebase = [];
  bool isLoading = true;
  String errorMessage = '';
  StreamSubscription<DatabaseEvent>? _booksSubscription;

  // Constantes
  static const String _databaseUrl = 'https://bookly-6db9d-default-rtdb.firebaseio.com/';
  static const Color _backgroundColor = Color(0xFFE1E3DD);

  @override
  void initState() {
    super.initState();
    _loadBooksFromFirebase();
  }

  @override
  void dispose() {
    _booksSubscription?.cancel();
    super.dispose();
  }

  // Función helper para obtener valores con fallbacks
  String _getValue(Map data, List<String> keys, String defaultValue) {
    for (String key in keys) {
      if (data[key] != null) return data[key].toString();
    }
    return defaultValue;
  }

  void _loadBooksFromFirebase() {
    _booksSubscription?.cancel();
    
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _databaseUrl
    ).ref();
    
    _booksSubscription = database.child('users').onValue.listen(
      (event) {
        final data = event.snapshot.value;
        List<Map<String, dynamic>> books = [];
        
        if (data is Map) {
          data.forEach((userId, userData) {
            if (userData is Map && userData['libros'] is Map) {
              (userData['libros'] as Map).forEach((libroKey, libroData) {
                if (libroData is Map) {
                  books.add(_createBookMap(libroData, userId.toString(), libroKey.toString()));
                }
              });
            }
          });
        }
        
        if (mounted) {
          setState(() {
            librosFromFirebase = books;
            isLoading = false;
            errorMessage = '';
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            errorMessage = 'Error de conexión: $error';
            isLoading = false;
          });
        }
      },
    );
  }

  Map<String, dynamic> _createBookMap(Map libroData, String userId, String libroKey) {
    return {
      'title': _getValue(libroData, ['Título', 'title', 'titulo'], 'Sin título'),
      'author': _getValue(libroData, ['Autor', 'author', 'autor'], 'Autor desconocido'),
      'year': _getValue(libroData, ['Año', 'year', 'anio'], 'Año desconocido'),
      'user': userId,
      'imagePath': _getValue(libroData, ['Imagen', 'imagePath', 'imageUrl', 'imagen'], ''),
      'libroId': libroKey,
      'userId': userId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('BOOKLY'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner.jpeg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 32),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LibrosForm())),
            tooltip: 'Agregar libro',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 32),
            tooltip: 'Perfil',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => vistaPerfil())),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (errorMessage.isNotEmpty) return _buildErrorState();
    if (isLoading) return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    if (librosFromFirebase.isEmpty) return _buildEmptyState();
    
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildBookCard(librosFromFirebase[index]),
        childCount: librosFromFirebase.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.48,
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage, style: const TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = '';
                });
                _loadBooksFromFirebase();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay libros publicados aún', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleLibro(
              titulo: book['title'] ?? 'Sin título',
              autor: book['author'] ?? 'Autor desconocido',
              anio: book['year'] ?? 'Año desconocido',
              usuario: book['user'] ?? 'Usuario desconocido',
              imagen: book['imagePath'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildBookImage(book['imagePath'] ?? ''),
        ),
      ),
    );
  }

  Widget _buildBookImage(String imagePath) {
    if (imagePath.isEmpty || !_isValidUrl(imagePath)) {
      return _buildPlaceholder('Sin imagen');
    }

    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder('Error al cargar imagen'),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      memCacheWidth: 300,
      memCacheHeight: 400,
      maxWidthDiskCache: 300,
      maxHeightDiskCache: 400,
    );
  }

  Widget _buildPlaceholder(String message) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.scheme.startsWith('http');
    } catch (e) {
      return false;
    }
  }
}