import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  final String password;

  const OtpPage({
    super.key,
    required this.phone,
    required this.password,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> nodes =
      List.generate(4, (_) => FocusNode());

  String? error;

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  @override
  void initState() {
    super.initState();

    // OTP otomatis terisi untuk keperluan testing
    controllers[0].text = "1";
    controllers[1].text = "2";
    controllers[2].text = "3";
    controllers[3].text = "4";
  }

  String getOtp() => controllers.map((e) => e.text).join();

  Future<void> verify() async {
    if (getOtp() != "1234") {
      setState(() => error = "Kode OTP yang Anda masukkan salah");
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('phone', widget.phone);
    await prefs.setString('password', widget.password);
    await prefs.setBool('isRegistered', true);
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    // Tampilkan notifikasi sukses sebelum pindah halaman
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Pendaftaran berhasil! Silakan login.",
          style: GoogleFonts.poppins(),
        ),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (r) => false,
    );
  }

  void onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(nodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      // Jika dihapus (backspace), otomatis mundur ke kotak sebelumnya
      if (index > 0) {
        FocusScope.of(context).requestFocus(nodes[index - 1]);
      }
    }
  }

  Widget box(int i) {
    return SizedBox(
      width: 56, // Sedikit diperlebar agar bentuknya kotak sempurna yang pas
      child: TextField(
        controller: controllers[i],
        focusNode: nodes[i],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: _textColorDark
        ),
        decoration: InputDecoration(
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
        ),
        onChanged: (v) => onChanged(v, i),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var n in nodes) {
      n.dispose();
    }
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
          "Verifikasi OTP",
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

              // 1. ILUSTASI UTAMA
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mark_email_unread_rounded,
                  size: 50,
                  color: _primaryColor,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Verifikasi Nomor Anda",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Kode OTP telah dikirimkan melalui SMS ke nomor ${widget.phone}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                 color: _textColorDark.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 2. KOTAK CONTAINER OTP FORM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Baris Kotak-Kotak Input OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        box(0),
                        box(1),
                        box(2),
                        box(3),
                      ],
                    ),

                    // Error text area jika salah kode
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        error!,
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // TOMBOL VERIFIKASI
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Verifikasi",
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
            ],
          ),
        ),
      ),
    );
  }
}