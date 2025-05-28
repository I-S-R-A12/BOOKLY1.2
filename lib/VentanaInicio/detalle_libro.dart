import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(imagen, height: 200)),
            const SizedBox(height: 20),
            Text('📖 Nombre del libro: $titulo', style: const TextStyle(fontSize: 18)),
            Text('✍️ Autor: $autor', style: const TextStyle(fontSize: 16)),
            Text('📅 Año de publicacion: $anio', style: const TextStyle(fontSize: 16)),
            Text('👤 Publicado por: $usuario', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
