import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Beranda/syarat_sewa_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔥 Import ini

class TombolSewaSekarang extends StatefulWidget {
  final String namaProduk;
  final String harga;
  final String fotoProduk;
  final Map<String, int> stok; // 🔥 Menerima data stok dari detail page
  final bool isKeranjang;

  const TombolSewaSekarang({
    super.key,
    required this.namaProduk,
    required this.harga,
    required this.fotoProduk,
    required this.stok,
    this.isKeranjang = false,
  });

  @override
  State<TombolSewaSekarang> createState() => _TombolSewaSekarangState();
}

class _TombolSewaSekarangState extends State<TombolSewaSekarang> {
  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  String _selectedUkuran = 'S';
  int _jumlahSewa = 1;

  Future<void> _tambahKeKeranjang(int hargaInt) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> keranjang =
      prefs.getStringList('keranjang') ?? [];

  final item = {
    "produk": widget.namaProduk,
    "harga": hargaInt,
    "foto": widget.fotoProduk,
    "ukuran": _selectedUkuran,
    "jumlah": _jumlahSewa,
    "stok": widget.stok[_selectedUkuran] ?? 0
  };

  keranjang.add(jsonEncode(item));

  await prefs.setStringList(
    'keranjang',
    keranjang,
  );
}
  
  void _showAuthMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Masuk ke Akun Anda", 
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _textColorDark)),
              const SizedBox(height: 8),
              Text("Silakan login atau daftar untuk mulai menyewa kostum favoritmu.", 
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 28),
              
              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login'); // Pastikan route '/login' ada
                  },
                  child: Text("Login", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              
              // TOMBOL REGISTRASI
              SizedBox(
                width: double.infinity, height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide(color: _primaryColor, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register'); // Pastikan route '/register' ada
                  },
                  child: Text("Registrasi", style: GoogleFonts.poppins(color: _primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  // Widget Helper untuk Button Counter +/-
  Widget _buildCounterButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.grey.shade100 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon, 
          size: 18, 
          color: onTap != null ? _textColorDark : Colors.grey.shade300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Mengambil data stok secara dinamis berdasarkan ukuran yang dipilih
    int maksimalStok = widget.stok[_selectedUkuran] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis Kecil Top Handle BottomSheet
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Info Singkat Produk
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: _bgColor,
                  width: 70,
                  height: 70,
                  child: Image.asset(widget.fotoProduk, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.namaProduk,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textColorDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.harga,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
          ),

          // Pilihan Ukuran
          Text(
            "Pilih Ukuran",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textColorDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: widget.stok.keys.map((ukuran) {
              bool isSelected = _selectedUkuran == ukuran;
              bool isTersedia = (widget.stok[ukuran] ?? 0) > 0;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: isTersedia
                      ? () {
                          setState(() {
                            _selectedUkuran = ukuran;
                            _jumlahSewa = 1; // Reset jumlah jika ganti ukuran
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _primaryColor
                          : (isTersedia ? Colors.white : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? _primaryColor
                            : (isTersedia ? Colors.grey.shade300 : Colors.grey.shade200),
                      ),
                    ),
                    child: Text(
                      ukuran,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (isTersedia ? _textColorDark : Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Info Stok & Jumlah Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jumlah Sewa",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textColorDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    maksimalStok > 0 ? "Stok tersedia: $maksimalStok" : "Stok Habis",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: maksimalStok > 0 ? Colors.grey.shade600 : Colors.red,
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  _buildCounterButton(
                    icon: Icons.remove,
                    onTap: _jumlahSewa > 1 ? () => setState(() => _jumlahSewa--) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "$_jumlahSewa",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textColorDark,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    icon: Icons.add,
                    onTap: _jumlahSewa < maksimalStok ? () => setState(() => _jumlahSewa++) : null,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Button Konfirmasi Lanjut
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: maksimalStok > 0 ? () async {
                final prefs = await SharedPreferences.getInstance();
                bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
                if (!isLoggedIn) {
                  // Jika belum login, ke Login
                  Navigator.pop(context); // Tutup modal
                  _showAuthMenu(context);
                  return; // Stop di sini
                }
                // Parse harga: "Rp 150k" → 150000, "Rp 150.000" → 150000
                final hargaRaw = widget.harga.toLowerCase();
                int hargaInt;
                if (hargaRaw.contains('k')) {
                  final angka = int.tryParse(hargaRaw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                  hargaInt = angka * 1000;
                } else {
                  hargaInt = int.tryParse(hargaRaw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                }

                if (widget.isKeranjang) {
                  await _tambahKeKeranjang(
                    hargaInt,
                  );

                  Navigator.pop(context);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Berhasil Ditambahkan Ke Keranjang", style: GoogleFonts.poppins()),
                      ),
                    );
                  }

                  return;
                }

                Navigator.pop(context); // Tutup Bottom Sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SyaratSewaPage(
                      namaProduk: widget.namaProduk,
                      hargaSatuan: hargaInt, // ✅ Nama parameter & tipe sudah benar (int)
                      fotoProduk: widget.fotoProduk,
                      ukuran: _selectedUkuran, // Data terpilih
                      jumlah: _jumlahSewa,     // Data terpilih
                    ),
                  ),
                );
              }
            :null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                maksimalStok > 0 
                ? widget.isKeranjang
                  ? "Tambahkan Ke Keranjang"
                  : "Lanjutkan Sewa"
                : "Stok Varian Habis",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}