/*import 'package:flutter/material.dart';

class DetalleLibro extends StatelessWidget {
  final String titulo;
  final String autor;
  final String anio;
  final String usuario;
  final String imagen;

  const DetalleLibro({
    super.key,
    required this.titulo,
    required this.autor,
    required this.anio,
    required this.usuario,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737B64),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'BOOKLY',
          style: TextStyle(
            fontFamily: 'sans-serif',
            color: Color.fromARGB(255, 8, 8, 8),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0x1FD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imagen, height: 250),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0x1FD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Nombre del libro: $titulo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Autor: $autor',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Año de publicación: $anio',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Publicado por: $usuario',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'sans-serif',
                      ),
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
*/