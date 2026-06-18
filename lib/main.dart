import 'package:flutter/material.dart';
import './Beranda/home_page.dart';
import './Profile/profile_page.dart';
import './Profile/edit_profile_page.dart';
import './Welcome/splash_page.dart';
import './Welcome/login_page.dart';
import './Welcome/register_page.dart';
import 'admin/admin_login_page.dart';
import 'admin/admin_home_page.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sewa Kostum CosRent',
      home: const SplashPage(),
      routes: {
        // 🔥 KEMBALI KE AWAL: Langsung memanggil HomePage()
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
         // 🔐 ADMIN APP
        '/admin_login': (context) => const AdminLoginPage(),
        '/admin_home': (context) => const AdminHomePage(),

      },
    );
  }
}