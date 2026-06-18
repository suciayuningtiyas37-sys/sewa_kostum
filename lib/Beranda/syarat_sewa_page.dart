import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../detail/form_sewa.dart'; // Pastikan path ini benar mengarah ke form_sewa.dart yang baru

class SyaratSewaPage extends StatelessWidget {
  final String namaProduk;
  final int hargaSatuan;
  final String fotoProduk;
  final String ukuran;
  final int jumlah;

  const SyaratSewaPage({
    super.key,
    required this.namaProduk,
    required this.hargaSatuan,
    required this.fotoProduk,
    required this.ukuran,
    required this.jumlah,
  });

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Syarat Penyewaan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BOX CONTAINER SYARAT & KETENTUAN (Biar Seirama)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Syarat & Ketentuan:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _textColorDark,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
                  ),
                  
                  // Item List Syarat Penyewaan
                  _buildSyaratItem("1.", "Isi data dan jadwal sewa dengan benar."),
                  _buildSyaratItem("2.", "Pengembalian sesuai tanggal & jam yang dipilih."),
                  _buildSyaratItem("3.", "Keterlambatan dikenakan biaya tambahan."),
                  _buildSyaratItem("4.", "Deposit 50% dari harga sewa."),
                  _buildSyaratItem("5.", "Deposit dikembalikan jika kondisi barang baik."),
                ],
              ),
            ),

            const Spacer(),

            // TOMBOL SETUJU & LANJUT
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0, // Flat design konsisten
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // 🔥 LEMPAR LAGI DATANYA KE FORM SEWA PAGE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormSewaPage(
                        namaProduk: namaProduk,
                        hargaSatuan: hargaSatuan,
                        fotoProduk: fotoProduk,
                        ukuran: ukuran,
                        jumlah: jumlah,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Setuju & Lanjut",
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
    );
  }

  // Widget Helper untuk Baris Teks Syarat agar Rapi
  Widget _buildSyaratItem(String nomor, String isiSyarat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$nomor  ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: _primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              isiSyarat,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
           color: _textColorDark.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}