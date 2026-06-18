import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sewa_kostum/Beranda/home_page.dart';

class DetailPenyewaanPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailPenyewaanPage({super.key, required this.item});

  // 🔥 FUNGSI UNTUK MEMINDAHKAN DATA KE RIWAYAT
  Future<void> _processReturn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Ambil list pesanan aktif
    List<String> activeList = prefs.getStringList('pesanan') ?? [];
    List<String> historyList = prefs.getStringList('riwayat') ?? [];
    // 2. Cari dan pindahkan item
    String idPesanan = item['idPesanan'];
    // Cari index item di list aktif
    int index = activeList.indexWhere((element) {
      Map<String, dynamic> map = jsonDecode(element);
      return map['idPesanan'] == idPesanan;
    });
    if (index != -1) {
      String dataString = activeList.removeAt(index);
      Map<String, dynamic> dataMap = jsonDecode(dataString);
      // Update status
      dataMap['status_rental'] = 'SELESAI';
      historyList.add(jsonEncode(dataMap));
      // Simpan kembali ke storage
      await prefs.setStringList('pesanan', activeList);
      await prefs.setStringList('riwayat', historyList);
    }

    // 3. Navigasi kembali ke Beranda (Bersihkan stack)
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  // 🔥 FUNGSI POPUP KONFIRMASI
  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Pengembalian", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Apakah kamu yakin ingin menyelesaikan masa sewa kostum ini?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Belum")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7F5539)),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              
              // Cek metode
              bool isDriver = item["metodePengembalian"] == "pickup";
              String msg = isDriver 
                  ? "Driver GoRent akan segera mengambil kostum di lokasimu." 
                  : "Kami tunggu kedatanganmu di toko untuk mengembalikan kostum.";

              // Tampilkan pesan kedua
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(msg, style: GoogleFonts.poppins()),
                  actions: [
                    TextButton(onPressed: () {
                      _processReturn(context); // Jalankan pindah data
                    }, child: const Text("OK")),
                  ],
                ),
              );
            },
            child: const Text("Sudah", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Palet warna konsisten
    final Color primaryColor = const Color(0xFF7F5539);
    final Color bgColor = const Color(0xFFFFF6EA);
    
    // Parsing data dengan aman
    final String foto = item["foto"] ?? item["fotoProduk"] ?? "assets/img/kebaya.jpg";
    final String produk = item["produk"]?.toString() ?? "-";
    final String ukuran = item["ukuran"]?.toString() ?? "-";
    final String harga = item["harga"]?.toString() ?? "0";
    final String jumlah = item["jumlah"]?.toString() ?? "1";
    final String ongkir = item["ongkir"]?.toString() ?? "0";
    final String deposit = item["deposit"]?.toString() ?? "0";
    final String total = item["total"]?.toString() ?? "0";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Detail Penyewaan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO PRODUK (Diperkecil & Estetik) ---
            Center(
              child: Container(
                height: 120, width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    foto,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- SECTION: PRODUK ---
           _buildCard([
  _infoRow("Nama Produk", produk, isBold: true),
  _infoRow("Ukuran", ukuran),
  _infoRow("Harga Sewa (+ Biaya Layanan)", "Rp $harga"),
  _infoRow("Jumlah", "$jumlah Pcs"),
]),

            // --- SECTION: JADWAL SEWA ---
            _buildSectionTitle("Jadwal Sewa", primaryColor),
            _buildCard([
              _infoRow("Tanggal Sewa", item["tanggalSewa"] ?? "-"),
              _infoRow("Jam Sewa", item["jamSewa"] ?? "-"),
              const Divider(),
              _infoRow("Tgl Kembali", item["tanggalKembali"] ?? "-"),
              _infoRow("Jam Kembali", item["jamKembali"] ?? "-"),
            ]),

            // --- SECTION: DATA PENYEWA ---
            _buildSectionTitle("Data Penyewa", primaryColor),
            _buildCard([
              _infoRow("Nama", item["nama"] ?? "-"),
              _infoRow("WhatsApp", item["wa"] ?? "-"),
              _infoRow("Alamat", item["alamat"] ?? "-"),
            ]),

            // --- SECTION: PEMBAYARAN ---
            _buildSectionTitle("Detail Pembayaran", primaryColor),
            _buildCard([
              _infoRow("Metode Pengambilan", item["metodeLayanan"] == "pickup" ? "Ambil Toko" : "Antar Driver"),
              _infoRow("Metode Pengembalian", item["metodePengembalian"] == "pickup" ? "Antar Ke Toko" : "Diambil Driver"),
              _infoRow("Metode Pembayaran", item["metodeBayar"] ?? "Transfer"),
              const Divider(),
              _infoRow("Harga Sewa (+ Biaya Layanan)", "Rp $harga"),
              _infoRow("Deposit", "Rp $deposit"),
              const Divider(thickness: 1.2),
              _infoRow("Total Bayar", "Rp $total", isBold: true, color: primaryColor, size: 15),
            ]),
            
            const SizedBox(height: 40),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7F5539),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _showReturnDialog(context),
          child: Text("Kembalikan Kostum", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildSectionTitle(String title, Color color) => Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 8),
    child: Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(15), 
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)]
    ),
    child: Column(children: children),
  );

  Widget _infoRow(String label, String value, {bool isBold = false, Color? color, double size = 12}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.black87,
              fontSize: size,
            ),
          ),
        ),
      ],
    ),
  );
}