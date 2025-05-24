import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class LibrosForm extends StatefulWidget {
  const LibrosForm({super.key});
  @override
  _LibrosFormState createState() => _LibrosFormState();
}

class _LibrosFormState extends State<LibrosForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _autor = TextEditingController();
  final TextEditingController _anio = TextEditingController();
  final TextEditingController _imagenUrl = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'Título': _titulo.text,
        'Autor': _autor.text,
        'Año': _anio.text,
        'Imagen': _imagenUrl.text,
      };

      final response = await http.post(
        Uri.parse('https://bookly-6db9d-default-rtdb.firebaseio.com/Libros.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Libro Publicado Correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al Publicar el Libro')),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 101, 158, 102), // Fondo verde
    appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 101, 158, 102),
  title: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 101, 158, 102),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      'BOOKLY',
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w900,
        fontSize: 28,
        letterSpacing: 2,
        fontStyle: FontStyle.italic,
        color: const Color.fromARGB(255, 6, 1, 1),
      ),
    ),
  ),
  centerTitle: true,
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(vertical: 16),
  margin: const EdgeInsets.only(bottom: 25),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 101, 158, 102), // Mismo verde que el fondo
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: const Color.fromARGB(255, 38, 48, 38), // Borde igual al fondo
      width: 1,
    ),
  ),
  child: const Center(
    child: Text(
      'Nuevo libro',
      style: TextStyle(
        color: Color.fromARGB(255, 24, 18, 18),
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 1,
                ),
              ),
               ),
            ),

              TextFormField(
                controller: _titulo,
                decoration: _inputDecoration('Título del libro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el titulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              TextFormField(
                controller: _autor,
                keyboardType: TextInputType.text,
                decoration: _inputDecoration('Nombre del Autor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del autor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _anio,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Año de publicación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el año de publicación del libro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _imagenUrl,
                decoration: _inputDecoration('URL de la Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la URL de la imagen';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Publicar Libro', style: TextStyle(fontSize: 16)),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}