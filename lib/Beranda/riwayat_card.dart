import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_riwayat_page.dart';

class RiwayatCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const RiwayatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    
    // Mengambil data dari map
    final String foto = item["foto"] ?? item["fotoProduk"] ?? "assets/img/kebaya.jpg";
    final String nama = item["produk"]?.toString() ?? "Kostum";
    final String total = item["total"]?.toString() ?? "0";
    final String tglSelesai = item["tanggalKembali"] ?? "-";

    final bool isDiterima = item["diterima"] ?? false;

    String statusMsg = item["metodePengembalian"] == "pickup" 
        ? "Segera anter kostum ke toko" 
        : "Driver GoRent telah diberangkatkan untuk mengambil kostum";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(foto, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nama, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF5C3B2E))),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDiterima ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isDiterima ? Colors.green.shade200 : Colors.red.shade200),
                        ),
                        child: Text(
                          isDiterima ? "Sudah Diterima" : "Belum Diterima",
                          style: GoogleFonts.poppins(
                            fontSize: 10, 
                            fontWeight: FontWeight.w600,
                            color: isDiterima ? Colors.green.shade700 : Colors.red.shade700
                          ),
                        ),
                      ),
                      Text(statusMsg, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Text("Rp $total", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: primaryColor)),
              ],
            ),
          ),
          
          // 🔥 Tombol Detail Riwayat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.03), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Selesai: $tglSelesai", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailRiwayatPage(item: item))),
                  child: Row(
                    children: [
                      Text("Detail", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 12)),
                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF7F5539)),
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