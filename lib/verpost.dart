import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final String imagePath;
  final String bookName;
  final String publishDate;
  final String author;
  final String postedBy;
  final String userId; // UID de Firebase del autor

  const PostScreen({
    super.key,
    required this.imagePath,
    required this.bookName,
    required this.publishDate,
    required this.author,
    required this.postedBy,
    required this.userId,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String? nombreUsuario;
  bool cargandoUsuario = true;

  @override
  void initState() {
    super.initState();
    obtenerNombreDelAutor(widget.userId);
  }

  // Obtiene el nombre del usuario que publicó la entrada usando su UID
  Future<void> obtenerNombreDelAutor(String uid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final idToken = await user.getIdToken();
    final url = Uri.parse(
      'https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/profile.json?auth=$idToken',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nombreUsuario = data['nombre'] ?? "Usuario desconocido";
          cargandoUsuario = false;
        });
      } else {
        print("Error al obtener nombre del autor: ${response.statusCode}");
        setState(() {
          cargandoUsuario = false;
          nombreUsuario = "Usuario desconocido";
        });
      }
    } catch (e) {
      print("Excepción al obtener nombre del autor: $e");
      setState(() {
        cargandoUsuario = false;
        nombreUsuario = "Usuario desconocido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737B64),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'BOOKLY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 367,
          height: 622,
          decoration: BoxDecoration(
            color: const Color(0x1FD9D9D9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imagePath,
                  width: 290,
                  height: 435,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 290,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x99D9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.bookName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(widget.publishDate, textAlign: TextAlign.center),
                    Text(widget.author, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      cargandoUsuario
                          ? 'Cargando autor...'
                          : 'Publicado por: $nombreUsuario',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
