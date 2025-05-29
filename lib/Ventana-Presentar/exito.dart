import 'package:flutter/material.dart';
// Asegúrate de importar tu pantalla de libros
import 'package:bookly12/VentanaInicio/home.dart';

class Exito extends StatelessWidget {
  const Exito({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Éxito')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              '¡Libro registrado exitosamente!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: const Text('Ver mis libros'),
            ),
          ],
        ),
      ),
    );
  }
}
