import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahKeranjang extends StatelessWidget {
  const TambahKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Memberikan efek rounded pada sisi atas modal
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      // Padding agar konten tidak menempel ke pinggir
      padding: const EdgeInsets.all(24),
      // MainAxisSize.min agar tinggi modal menyesuaikan isi konten
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle (garis kecil di atas modal)
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          
          Text("Konfirmasi", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Text("Apakah kamu ingin menambahkan kostum ini ke keranjang?", textAlign: TextAlign.center),
          
          const SizedBox(height: 24),
          
          // Tombol Aksi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7F5539)),
              onPressed: () {
                // Di sini nanti logika untuk save ke shared_preferences / database
                Navigator.pop(context); // Tutup modal
              },
              child: Text("Ya, Tambahkan", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}