import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 🔥 TAMBAHKAN KONTROLLER UNTUK INPUT NAMA
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _namaError; // 🔥 Error state nama
  String? _phoneError;
  String? _passwordError;

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  bool _validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasMinLength && hasLetter && hasNumber;
  }

  Future<void> _next() async {
    final nama = _namaController.text.trim(); // 🔥 Ambil value nama
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    String? namaError; // 🔥 Error string nama
    String? phoneError;
    String? passwordError;

    // 🔥 Validasi input nama tidak boleh kosong
    if (nama.isEmpty) {
      namaError = "Nama lengkap tidak boleh kosong";
    }

    if (phone.isEmpty) {
      phoneError = "Nomor HP tidak boleh kosong";
    } else if (!RegExp(r'^\d{10,13}$').hasMatch(phone)) {
      phoneError = "Nomor HP harus berupa 10-13 digit angka";
    }

    if (!_validatePassword(password)) {
      passwordError = "Min 8 karakter berisi huruf dan angka";
    }

    setState(() {
      _namaError = namaError; // 🔥 Set error state nama
      _phoneError = phoneError;
      _passwordError = passwordError;
    });

    if (namaError != null || phoneError != null || passwordError != null) return;

    final prefs = await SharedPreferences.getInstance();
    
    // 🔥 SEKARANG DATA NAMA IKUT TERSIMPAN SEJAK AWAL DAFTAR
    await prefs.setString('nama', nama); 
    await prefs.setString('name', nama); // Disimpan ke kedua key biar aman dan sinkron dengan profile
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpPage(
          phone: phone,
          password: password,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose(); // 🔥 Jangan lupa di-dispose
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Daftar Akun",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. ILUSTRASI UTAMA
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 50,
                  color: _primaryColor,
                ),
              ),
              
              const SizedBox(height: 16),

              Text(
                "Buat Akun Baru",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark,
                ),
              ),
              Text(
                "Daftarkan diri Anda untuk mulai menyewa di CosRent",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: _textColorDark.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 30),

              // 2. CONTAINER INPUT FORM BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // 🔥 INPUT NAMA LENGKAP (BARU)
                    TextField(
                      controller: _namaController,
                      keyboardType: TextInputType.name,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        labelStyle: GoogleFonts.poppins(color: _textColorDark.withOpacity(0.6)),
                        errorText: _namaError,
                        errorStyle: GoogleFonts.poppins(fontSize: 11),
                        prefixIcon: Icon(Icons.person_outline_rounded, color: _primaryColor, size: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // INPUT NOMOR HP
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "No HP",
                        labelStyle: GoogleFonts.poppins(color: _textColorDark.withOpacity(0.6)),
                        errorText: _phoneError,
                        errorStyle: GoogleFonts.poppins(fontSize: 11),
                        prefixIcon: Icon(Icons.phone_android_rounded, color: _primaryColor, size: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // INPUT PASSWORD
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(color: _textColorDark.withOpacity(0.6)),
                        errorText: _passwordError,
                        errorStyle: GoogleFonts.poppins(fontSize: 11),
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: _primaryColor, size: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // TOMBOL LANJUT
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Lanjut",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // KEMBALI KE LOGIN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: GoogleFonts.poppins(
                      color: _textColorDark.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}