import 'package:flutter/material.dart';
// Importa la pantalla donde se muestran los libros
import 'package:bookly12/VentanaInicio/home.dart'; // Cambia el nombre si tu pantalla tiene otro

class Exito extends StatefulWidget {
  const Exito({super.key});

  @override
  State<Exito> createState() => _ExitoState();
}

class _ExitoState extends State<Exito> {
  @override
  void initState() {
    super.initState();
    // Después de 2.5 segundos, redirige a la pantalla de libros
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6), // fondo tipo popup
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 70),
              SizedBox(height: 16),
              Text(
                '¡Libro registrado\nexitosamente!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
