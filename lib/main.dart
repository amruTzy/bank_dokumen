import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/splash/splash_screen.dart'; // ganti ke splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib sebelum Firebase.init
  await Firebase.initializeApp();            // inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Dokumen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // start dari splash
    );
  }
}
