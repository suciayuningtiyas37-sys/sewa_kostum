import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRiwayatPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailRiwayatPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    final String total = item["total"]?.toString() ?? "0";
    final String foto = item["foto"] ?? item["fotoProduk"] ?? "assets/img/kebaya.jpg";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),
      appBar: AppBar(
        title: Text("Detail Riwayat", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // 🔥 PEMANGGILAN FUNGSI (Sudah benar di sini)
            _buildSectionTitle("Status Transaksi", primaryColor),
            _buildCard([
              _infoRow("Status", "Belum Dikembalikan"),
            ]),

            _buildSectionTitle("Data Penyewa", primaryColor),
            _buildCard([
              _infoRow("Nama", item["nama"] ?? "-"),
              _infoRow("WhatsApp", item["wa"] ?? "-"),
              _infoRow("Alamat", item["alamat"] ?? "-"),
            ]),
            
            _buildSectionTitle("Informasi Kostum", primaryColor),
            _buildCard([
               _infoRow("Nama Produk", item["produk"]?.toString() ?? "-"),
               _infoRow("Total Bayar", "Rp $total"),
               _infoRow("Jumlah", "${item["jumlah"]?.toString() ?? "1"} Pcs"),
            ]),

            // ... tambahkan sisa detail lainnya di sini ...
            _buildSectionTitle("Jadwal Sewa", primaryColor),
            _buildCard([
              _infoRow("Tanggal Sewa", item["tanggalSewa"] ?? "-"),
              _infoRow("Jam Sewa", item["jamSewa"] ?? "-"),
              const Divider(), // Garis pemisah estetik
              _infoRow("Tgl Kembali", item["tanggalKembali"] ?? "-"),
              _infoRow("Jam Kembali", item["jamKembali"] ?? "-"),
            ]),

            _buildSectionTitle("Detail Pembayaran", primaryColor),
            _buildCard([
              _infoRow("Metode Pengambilan", item["metodeLayanan"] == "pickup" ? "Ambil Toko" : "Antar Driver"),
              _infoRow("Metode Pengembalian", item["metodePengembalian"] == "pickup" ? "Antar Ke Toko" : "Diambil Driver"),
              _infoRow("Metode Pembayaran", item["metodeBayar"] ?? "Transfer"),
              const Divider(),
              _infoRow("Harga Sewa", "Rp ${item["harga"] ?? "0"}"),
              _infoRow("Deposit", "Rp ${item["deposit"] ?? "0"}"),
              const Divider(thickness: 1.2),
              _infoRow("Total Bayar", "Rp ${item["total"] ?? "0"}", isBold: true, color: primaryColor, size: 15),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 🔥 DEFINISI FUNGSI HARUS DI LUAR BUILD (Di sini tempatnya)

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