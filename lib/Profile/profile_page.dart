import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import 'package:sewa_kostum/Beranda/home_page.dart';
import '../Welcome/Login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = "Belum diisi";
  String wa = "Belum diisi";
  String alamat = "Belum diisi";
  String? _dummyImagePath; 

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);
  final Color _accentColor = const Color(0xFFD4A373);

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    final prefs = await SharedPreferences.getInstance();

    String alamatDetail = prefs.getString('alamat_detail') ?? '';
    String kelurahan = prefs.getString('kelurahan') ?? '';
    String kecamatan = prefs.getString('kecamatan') ?? '';
    String kodePos = prefs.getString('kode_pos') ?? ''; 

    setState(() {
      nama = prefs.getString('nama') ?? prefs.getString('name') ?? "Belum diisi"; 
      wa = prefs.getString('phone') ?? "Belum diisi";

      if (alamatDetail.isEmpty && kelurahan.isEmpty && kecamatan.isEmpty && kodePos.isEmpty) {
        alamat = "Belum diisi";
      } else {
        StringBuffer sb = StringBuffer();
        if (alamatDetail.isNotEmpty) sb.write(alamatDetail);
        if (kelurahan.isNotEmpty) sb.write("\nKel. $kelurahan");
        if (kecamatan.isNotEmpty) sb.write(", Kec. $kecamatan");
        if (kodePos.isNotEmpty) sb.write("\nKode Pos: $kodePos");
        
        alamat = sb.toString();
      }

      _dummyImagePath = prefs.getString('dummy_profile');
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Keluar Akun", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: _textColorDark)),
        content: Text("Anda yakin ingin keluar dari akun ini?", style: GoogleFonts.poppins(color: _textColorDark)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal", style: GoogleFonts.poppins(color: _textColorDark))),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Hapus sesi
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // Pastikan import LoginPage sudah benar
                (route) => false,
              );
            },
            child: Text("Keluar", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _showLogoutDialog(context), // Memanggil fungsi dialog
          ),
        ],
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. AVATAR PROFIL INTERAKTIF DUMMY
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _accentColor, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 46, 
                    backgroundColor: Colors.grey.shade200, 
                    backgroundImage: _dummyImagePath != null 
                        ? AssetImage(_dummyImagePath!) 
                        : null,
                    child: _dummyImagePath == null
                        ? Icon(
                            Icons.person,
                            size: 52, 
                            color: Colors.grey.shade400, 
                          )
                        : null,
                  ),
                ),
              ),
              
              const SizedBox(height: 14),
              
              Text(
                nama,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),

              // 2. CARD DATA INFO PROFIL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    _buildProfileItem(
                      icon: Icons.person_outline_rounded,
                      label: "Nama Lengkap",
                      value: nama,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
                    ),
                    _buildProfileItem(
                      icon: Icons.phone_android_rounded,
                      label: "No. WhatsApp",
                      value: wa,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
                    ),
                    _buildProfileItem(
                      icon: Icons.location_on_outlined,
                      label: "Alamat Lengkap & Tujuan Pengiriman",
                      value: alamat, 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= BOTTOM NAVIGATION BAR =================
      // 🔥 Pindiah ke bawah sini agar menjadi tombol utama yang kokoh
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          color: _bgColor,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
                if (result == true) {
                  _loadProfil(); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit_note_rounded, size: 22),
              label: Text(
                "Ubah Profil Saya",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
            color: _textColorDark.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}