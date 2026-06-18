import 'dart:async'; // 🔥 Diperlukan untuk simulasi timer otomatis
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'struk_pesanan_page.dart';

class BarcodePembayaranPage extends StatefulWidget {
  final String nama;
  final String wa;
  final String alamat;
  final String produk;
  final int harga;
  final int hargaSatuan;
  final String ukuran;
  final String metodeLayanan;
  final String metodePengembalian;
  final String tanggalSewa;
  final String jamSewa;
  final String tanggalKembali;
  final String jamKembali;
  final String metodeBayar;
  final int totalBayar;
  final String fotoProduk;
  final int deposit;
  final int ongkir;
  final int jumlah;
  final int biayaOngkirBalik;
  final int totalHargaKostum;

  const BarcodePembayaranPage({
    super.key,
    required this.nama,
    required this.wa,
    required this.alamat,
    required this.produk,
    required this.harga,
    required this.hargaSatuan,
    required this.ukuran,
    required this.metodeLayanan,
    required this.metodePengembalian,
    required this.tanggalSewa,
    required this.jamSewa,
    required this.tanggalKembali,
    required this.jamKembali,
    required this.metodeBayar,
    required this.totalBayar,
    required this.fotoProduk,
    required this.deposit,
    required this.ongkir,
    required this.jumlah,
    required this.biayaOngkirBalik,
    required this.totalHargaKostum,
  });

  @override
  State<BarcodePembayaranPage> createState() => _BarcodePembayaranPageState();
}

class _BarcodePembayaranPageState extends State<BarcodePembayaranPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 🔥 SIMULASI SISTEM: Menunggu 4 detik, lalu sistem otomatis memunculkan pop-up berhasil
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        _showSuccessDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Batalkan timer jika user keluar sebelum 4 detik agar tidak memory leak
    super.dispose();
  }

  // 🔥 POP-UP NOTIFIKASI OTOMATIS DARI SISTEM
  void _showSuccessDialog(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    final Color textColorDark = const Color(0xFF5C3B2E);

    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa menutup sembarangan, harus klik tombol
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Berhasil Terverifikasi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Judul Notifikasi
                Text(
                  "Pembayaran Berhasil!",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Deskripsi Notifikasi
                Text(
                  "Sistem CosRent telah mengonfirmasi pembayaran otomatis kamu. Silakan klik tombol di bawah untuk melihat struk belanja.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 24),
                
                // Tombol Lanjut Ke Struk
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup Pop-up dialog
                      
                      // Pindah ke halaman struk pesanan
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StrukPesananPage(
                            nama: widget.nama,
                            wa: widget.wa,
                            alamat: widget.alamat,
                            produk: widget.produk,
                            harga: widget.harga,
                            hargaSatuan: widget.hargaSatuan,
                            ukuran: widget.ukuran,
                            metodeLayanan: widget.metodeLayanan,
                            metodePengembalian: widget.metodePengembalian,
                            tanggalSewa: widget.tanggalSewa,
                            jamSewa: widget.jamSewa,
                            tanggalKembali: widget.tanggalKembali,
                            jamKembali: widget.jamKembali,
                            metodeBayar: widget.metodeBayar,
                            totalBayar: widget.totalBayar,
                            fotoProduk: "${widget.fotoProduk}",
                            deposit: widget.deposit,
                            ongkir: widget.ongkir,
                            jumlah: widget.jumlah,
                            biayaOngkirBalik: widget.biayaOngkirBalik,
                            totalHargaKostum: widget.totalHargaKostum,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Lihat Struk Pesanan",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    final Color textColorDark = const Color(0xFF5C3B2E);
    final Color bgColor = const Color(0xFFFFF6EA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text("Pembayaran QRIS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Pindai QRIS untuk Membayar",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textColorDark),
            ),
            const SizedBox(height: 4),
            Text(
              "CosRent Pembayaran Otomatis",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // KOTAK BARCODE/QRIS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text("TOTAL TAGIHAN", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text("Rp ${widget.totalBayar}", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: primaryColor)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.qr_code_2_rounded, size: 160, color: textColorDark),
                  ),
                  const SizedBox(height: 16),
                  
                  // 🔥 INDIKATOR LOADING SISTEM MENUNGGU PEMBAYARAN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Menunggu pembayaran kamu masuk...",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PETUNJUK TRANSFER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cara Pembayaran:", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: textColorDark)),
                  const SizedBox(height: 8),
                  Text("1. Buka aplikasi e-wallet (Gojek, OVO, Dana) atau M-Banking Anda.\n2. Pilih menu Scan/Bayar QRIS.\n3. Arahkan kamera ke barcode di atas.\n4. Periksa nominal lalu konfirmasi pembayaran.", 
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}