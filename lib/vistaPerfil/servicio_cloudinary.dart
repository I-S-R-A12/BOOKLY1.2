
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class SubirArchivosACloudinary {

     // Método para seleccionar una imagen desde la galería y subirla a Cloudinary
  static Future<String?> seleccionarYSubirImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final cloudName = 'dinyl4phx';       
    final uploadPreset = 'fotos_perfil'; 

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset;

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: pickedFile.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('file', pickedFile.path),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);
      // Retorna la URL pública de la imagen
      return resJson['secure_url'];
    } else {
      throw Exception('Error al subir imagen a Cloudinary');
    }
  }
}