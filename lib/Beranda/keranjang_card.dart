import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeranjangCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onUpdate; // Dipanggil saat jumlah berubah
  final VoidCallback onDelete; // Dipanggil saat tombol hapus ditekan
  final VoidCallback onSewa;

  const KeranjangCard({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
    required this.onSewa,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7F5539);
    
    // Mengambil data dari map
    final String foto = item["foto"] ?? item["fotoProduk"] ?? "assets/img/kebaya.jpg";
    final String nama = item["produk"]?.toString() ?? "Kostum";
    final int harga = int.tryParse(item["harga"].toString()) ?? 0;
    final int jumlah = item["jumlah"] ?? 1;
    final String ukuran = item["ukuran"]?.toString() ?? "-";
    final int stok = item["stok"] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  foto, 
                  width: 110, 
                  height: 110, 
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 110, height: 110, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded( // Expanded di sini agar text tidak "overflow"
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(nama, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("Rp $harga", style: GoogleFonts.poppins(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("Ukuran : $ukuran", style: GoogleFonts.poppins(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("Qty : $stok", style: GoogleFonts.poppins(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () { if(jumlah > 1) { item["jumlah"]--; onUpdate(); } },
                child: const Icon(Icons.remove_circle_outline, size: 28, color: Color(0xFF7F5539)), // Ikon diperbesar ke 28
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("$jumlah", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              InkWell(
                onTap: () { if(jumlah < stok) { item["jumlah"]++; onUpdate(); } },
                child: const Icon(Icons.add_circle_outline, size: 28, color: Color(0xFF7F5539)), // Ikon diperbesar ke 28
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
                onPressed: onDelete,
              ),
            ],
          ),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: onSewa,
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
              label: Text("SEWA SEKARANG", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F5539),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}