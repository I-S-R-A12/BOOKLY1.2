import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class DetalleLibroDesdeFirebase extends StatefulWidget {
  @override
  _DetalleLibroDesdeFirebaseState createState() => _DetalleLibroDesdeFirebaseState();
}

class _DetalleLibroDesdeFirebaseState extends State<DetalleLibroDesdeFirebase> {
  bool _isLoading = true;
  Map<String, dynamic>? _libro;
  String _nombreUsuario = 'Usuario desconocido';
  String _imagenUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchPrimerLibro();
  }

  Future<void> _fetchPrimerLibro() async {
    try {
      final url = Uri.parse('https://bookly-6db9d-default-rtdb.firebaseio.com/users.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          for (var userEntry in data.entries) {
            final userData = userEntry.value;
            final nombreUsuario = userData['profile']?['nombre'] ?? 'Usuario desconocido';
            final libros = userData['libros'] as Map<String, dynamic>?;

            if (libros != null && libros.isNotEmpty) {
              final libro = libros.entries.first.value as Map<String, dynamic>;
              final imagenCruda = libro['Imagen']?.toString() ?? '';
              final imagenLimpia = _cleanImageUrl(imagenCruda);

              final imagenValida = await _testImageUrl(imagenLimpia);
              setState(() {
                _libro = libro;
                _nombreUsuario = nombreUsuario;
                _imagenUrl = imagenValida ? imagenLimpia : '';
                _isLoading = false;
              });
              return;
            }
          }
        }
      } else {
        throw Exception('Error al cargar datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener libros: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();
    return validExtensions.any((ext) => lowerUrl.contains(ext));
  }

  String _cleanImageUrl(String url) {
    if (url.isEmpty) return '';
    String cleanUrl = url.trim();
    if (cleanUrl.contains('?')) {
      cleanUrl = cleanUrl.split('?')[0];
    }
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }
    return cleanUrl;
  }

  Future<bool> _testImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url)).timeout(const Duration(seconds: 5));
      return response.statusCode == 200 &&
          (response.headers['content-type']?.startsWith('image/') ?? false);
    } catch (e) {
      print('Error probando URL: $url - $e');
      return false;
    }
  }

  Widget _buildRobustImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
      placeholder: (context, _) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, _, __) => const Icon(Icons.broken_image, size: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titulo = _libro?['Título'] ?? 'Sin título';
    final autor = _libro?['Autor'] ?? 'Desconocido';
    final anio = _libro?['Año'] ?? 'Desconocido';

    return Scaffold(
      backgroundColor: const Color(0xFF737B64),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'BOOKLY',
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _libro == null
              ? const Center(child: Text('No hay libros disponibles'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _imagenUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _buildRobustImage(_imagenUrl),
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text('Autor: $autor', style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text('Año: $anio', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Publicado por: $_nombreUsuario', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
