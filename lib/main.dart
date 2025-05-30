import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
=======
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> c988edbe1b1e82547125505dcb128d523b1ebe65
import 'firebase_options.dart';

// Asegurate que la ruta sea correcta y el archivo 'login.dart' no tenga errores.
import 'package:bookly12/VentanaInicio/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const LoginWithGoogle(), // Pantalla principal
    );
  }
}
