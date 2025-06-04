import 'package:bookly12/Ventana-Presentar/exito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Añadido para Firestore

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
  
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Usuario no autenticado'),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final uid = user.uid;
        final idToken = await user.getIdToken();

        final data = {
          'Título': _titulo.text,
          'Autor': _autor.text,
          'Año': _anio.text,
          'Imagen': _imagenUrl.text,
          'fechaCreacion': DateTime.now().millisecondsSinceEpoch,
        };

        // Guardar en Firebase Realtime Database (código original)
        final response = await http.post(
          Uri.parse(
            'https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/libros.json?auth=$idToken',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Guardar solo la URL de imagen en Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('libros')
              .add({
            'Imagen': _imagenUrl.text,
            'fechaCreacion': FieldValue.serverTimestamp(),
          });

          _titulo.clear();
          _autor.clear();
          _anio.clear();
          _imagenUrl.clear();
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Exito()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737B64), // Fondo verde oliva
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header con flecha y título
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 28,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'BOOKLY',
                          style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            letterSpacing: 2,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Para balancear el espacio del IconButton
                  ],
                ),
                
                const SizedBox(height: 30),

                // Banner "Nuevo libro"
                Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BA285), // Verde más claro
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Nuevo libro',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                const SizedBox(height: 25),

                // Sección Nombre del libro
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nombre del libro',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _titulo,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribir nombre del libro',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el título';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 20),

                // Sección Autor
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Autor',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _autor,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribir nombre del Autor del libro',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del autor';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 20),

                // Sección Año de publicación
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Año de publicación',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _anio,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribir año de la publicación del libro',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      counterText: '', // Ocultar contador
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el año de publicación del libro';
                      }
                      if (value.length != 4) {
                        return 'Debe contener exactamente 4 dígitos';
                      }
                      final anio = int.tryParse(value);
                      final currentYear = DateTime.now().year;
                      if (anio == null || anio < 1000 || anio > currentYear) {
                        return 'Ingrese un año válido (hasta $currentYear)';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 20),

                // Sección URL de imagen
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'URL de imagen',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _imagenUrl,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Pegar URL de la imagen en este espacio',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la URL de la imagen';
                      }
                      final RegExp imageUrlRegExp = RegExp(
                        r'^https?:\/\/.*\.(jpg|jpeg|png)$',
                        caseSensitive: false,
                      );
                      if (!imageUrlRegExp.hasMatch(value)) {
                        return 'La URL debe terminar en .jpg, .jpeg o .png';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Botón Publicar libro
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black54,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Publicar libro',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}