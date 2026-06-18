import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _waController = TextEditingController();
  final _alamatDetailController = TextEditingController(); 
  final _kecamatanController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kodePosController = TextEditingController(); // 🔥 Kolom Kode Pos

  // State untuk menyimpan status foto profil dummy (null berarti kosong)
  String? _dummyImagePath; 

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);
  final Color _accentColor = const Color(0xFFD4A373);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 🔥 FIX: Fungsi memuat data yang menjamin data Kode Pos ter-render ke layar
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _namaController.text = prefs.getString('nama') ?? prefs.getString('name') ?? '';
    _waController.text = prefs.getString('phone') ?? '';
    _alamatDetailController.text = prefs.getString('alamat_detail') ?? '';
    _kecamatanController.text = prefs.getString('kecamatan') ?? '';
    _kelurahanController.text = prefs.getString('kelurahan') ?? '';
    _kodePosController.text = prefs.getString('kode_pos') ?? ''; // 🔥 Memuat data kode pos

    setState(() {
      _dummyImagePath = prefs.getString('dummy_profile');
    });
  }

  // Fungsi Dialog Pilihan Foto (Dummy Interaktif)
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ubah Foto Profil",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded, color: _primaryColor),
                title: Text("Ambil Foto", style: GoogleFonts.poppins(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _simulatePickPhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library_rounded, color: _primaryColor),
                title: Text("Pilih dari Galeri", style: GoogleFonts.poppins(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _simulatePickPhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulatePickPhoto() {
    setState(() {
      _dummyImagePath = 'assets/img/kebaya.jpg'; 
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Foto profil berhasil diperbarui", style: GoogleFonts.poppins()),
      ),
    );
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nama', _namaController.text.trim());
    await prefs.setString('name', _namaController.text.trim());
    await prefs.setString('alamat_detail', _alamatDetailController.text.trim());
    await prefs.setString('kecamatan', _kecamatanController.text.trim());
    await prefs.setString('kelurahan', _kelurahanController.text.trim());
    await prefs.setString('kode_pos', _kodePosController.text.trim()); // 🔥 Menyimpan data kode pos
    
    if (_dummyImagePath != null) {
      await prefs.setString('dummy_profile', _dummyImagePath!);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _waController.dispose();
    _alamatDetailController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kodePosController.dispose(); 
    super.dispose();
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon, String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: GoogleFonts.poppins(color: _textColorDark.withValues(alpha: 0.6)),
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
      errorStyle: GoogleFonts.poppins(fontSize: 11),
      prefixIcon: Icon(icon, color: _primaryColor, size: 20),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profil Saya",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: _accentColor, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _dummyImagePath != null 
                              ? AssetImage(_dummyImagePath!) 
                              : null,
                          child: _dummyImagePath == null 
                              ? Icon(Icons.person, size: 55, color: Colors.grey.shade400) 
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: _showPhotoOptions,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                 color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _dummyImagePath == null ? "Belum Ada Foto" : "Foto Profil Terpasang",
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: _textColorDark.withValues(alpha: 0.5)),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. NAMA LENGKAP
                      TextFormField(
                        controller: _namaController,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _buildInputDecoration(label: "Nama Lengkap", icon: Icons.person_outline_rounded),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? "Nama tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 16),

                      // 2. NO WHATSAPP (READ ONLY)
                      TextFormField(
                        controller: _waController,
                        readOnly: true,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                        decoration: _buildInputDecoration(label: "No. WhatsApp (ReadOnly)", icon: Icons.phone_android_rounded),
                      ),
                      const SizedBox(height: 16),

                      // 3. ALAMAT DETAIL (Sekarang berada di posisi atas wilayah)
                      TextFormField(
                        controller: _alamatDetailController,
                        maxLines: 3,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _buildInputDecoration(
                          label: "Alamat Lengkap & Detail Jalan",
                          icon: Icons.home_work_outlined,
                          hintText: "Contoh: Jl. Kaliabang Tengah No.8 RT01 RW02, Samping Posyandu Cemara",
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? "Alamat detail wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),

                      // 4. KECAMATAN (Berada di bawah Alamat Detail)
                      TextFormField(
                        controller: _kecamatanController,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _buildInputDecoration(label: "Kecamatan", icon: Icons.map_outlined, hintText: "Contoh: Bekasi Utara"),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? "Kecamatan wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),

                      // 5. KELURAHAN (Berada di bawah Alamat Detail)
                      TextFormField(
                        controller: _kelurahanController,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _buildInputDecoration(label: "Kelurahan / Desa", icon: Icons.location_city_rounded, hintText: "Contoh: Kaliabang Tengah"),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? "Kelurahan wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),

                      // 6. KODE POS (🔥 Paling bawah)
                      TextFormField(
                        controller: _kodePosController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _buildInputDecoration(label: "Kode Pos", icon: Icons.local_post_office_outlined, hintText: "Contoh: 17125"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Kode pos wajib diisi";
                          } else if (!RegExp(r'^\d{5}$').hasMatch(value.trim())) {
                            return "Kode pos harus berupa 5 digit angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // TOMBOL SIMPAN
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _saveData();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Profil berhasil diperbarui", style: GoogleFonts.poppins()),
                                ),
                              );
                              Navigator.pop(context, true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Simpan Perubahan",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
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
      ),
    );
  }
}