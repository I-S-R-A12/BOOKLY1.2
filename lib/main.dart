

import 'package:BOOKLY/VentanaInicio/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  // Inicializa las vinculaciones de Flutter necesarias para ejecutar código antes de llamar a runApp()
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con la configuración correspondiente a la plataforma actual (Android, iOS, Web, etc.)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: LoginWithGoogle(),
      home: SplashScreen(),
    );
  }
}
