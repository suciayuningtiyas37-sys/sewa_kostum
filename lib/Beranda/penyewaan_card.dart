import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewa_kostum/Beranda/detail_penyewaan_page.dart';

class PenyewaanCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const PenyewaanCard({super.key, required this.item});

  String _hitungSisaWaktu(String? tanggalKembali) {
    if (tanggalKembali == null) return "Aktif";
    // ... logika sisa waktu kamu ...
    return "Sisa 3 Hari";
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    
    // 🔥 DATA DUMMY (Fallback jika item kosong atau untuk tampilan sementara)
    final String fotoProduk = item["fotoProduk"] ?? "assets/img/kebaya.jpg";
    final String namaKostum = item["produk"]?.toString() ?? "Kebaya Modern";
    final String ukuran = item["ukuran"]?.toString() ?? "-";
    final String hargaPerHari = item["hargaSatuan"]?.toString() ?? "150.000";
    final String harga = item ["harga"]?.toString() ?? "-" ;
    final String jumlah = item["jumlah"]?.toString() ?? "1";
    final String totalHarga = item["total"]?.toString() ?? "150.000";
    final String idPesanan = item["idPesanan"] ?? "INV-DUMMY";
    final String jamSewa = item["jamSewa"] ?? "-";
    final String jamKembali = item["jamKembali"] ?? "-";
    final String wa = item["wa"] ?? "-";
    
    final String sisaWaktu = _hitungSisaWaktu(item["tanggalKembali"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: primaryColor.withValues(alpha: 0.1),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ],
),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ID: $idPesanan", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(sisaWaktu, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor)),
                ),
              ],
            ),
          ),
          
          // Body (Foto, Nama, Harga, Qty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(fotoProduk, width: 70, height: 70, fit: BoxFit.cover, 
                    errorBuilder: (_,__,___) => const Icon(Icons.camera_alt_outlined, size: 50)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$namaKostum", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF5C3B2E))),
                      Text("Rp $hargaPerHari /hari", style: GoogleFonts.poppins(fontSize: 12, color: primaryColor)),
                      Text("Qty: $jumlah pcs", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer (Total & Tombol Detail)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.03), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: Rp $totalHarga", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryColor)),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPenyewaanPage(item: item))),
                  child: Row(
                    children: [
                      Text("Detail", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: primaryColor)),
                      const Icon(Icons.chevron_right, size: 18, color: Color(0xFF7F5539)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}