import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  String? emailError;
  String? passError;

  void _login() {
    setState(() {
      emailError = userController.text.isEmpty ? "Harap isi email" : null;
      passError = passController.text.isEmpty ? "Harap isi password" : null;
    });

    if (emailError == null && passError == null) {
      if (userController.text == "admin@gmail.com" &&
          passController.text == "1234") {
        Navigator.pushReplacementNamed(context, '/admin_home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal, coba lagi")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Login"),
        backgroundColor: const Color(0xFFE6D5C3),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Masuk sebagai Admin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7F5539),
                ),
              ),
              const SizedBox(height: 32),

              // Email Field
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError,
                  filled: true,
                  fillColor: const Color(0xFFFCEFE3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF7F5539)),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passError,
                  filled: true,
                  fillColor: const Color(0xFFFCEFE3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF7F5539)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDDB892),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
