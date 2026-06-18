import 'dart:async';
import 'package:flutter/material.dart';
import '../Beranda/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    // pindah otomatis ke homepage setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // Logo
            Image.asset(
              'assets/img/CosRent_Logo.png',
              height: 140,
            ),

            const SizedBox(height: 30),

            // Tulisan welcome
            const Text(
              'Halo👋',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7F5539),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Selamat Datang di CosRent',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF7F5539),
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Color(0xFF7F5539),
            ),
          ],
        ),
      ),
    );
  }
}