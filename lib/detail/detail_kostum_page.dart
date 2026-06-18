import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../chat/chat.page.dart';
import 'tombol_sewa_sekarang.dart';

class DetailKostumPage extends StatelessWidget {
  final String namaProduk;
  final String harga;
  final String deskripsi;
  final String fotoProduk;
  final Map<String, int> stok; // 🔥 Terima parameter stok dari kartu baju

  const DetailKostumPage({
    super.key,
    required this.namaProduk,
    required this.harga,
    required this.deskripsi,
    required this.fotoProduk,
    required this.stok, // 🔥 Tambahkan di konstruktor
  });

  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  void _showSewaBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return TombolSewaSekarang(
          namaProduk: namaProduk,
          harga: harga,
          fotoProduk: fotoProduk,
          stok: stok,
          isKeranjang: false,
        );
      },
    );
  }

  void _showKeranjangBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return TombolSewaSekarang(
        namaProduk: namaProduk,
        harga: harga,
        fotoProduk: fotoProduk,
        stok: stok,
        isKeranjang: true,
      );
    },
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
        title: Text(
          "Detail Kostum",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 280,
                      padding: const EdgeInsets.all(16),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(fotoProduk, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            namaProduk,
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: _textColorDark),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            harga,
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: _primaryColor),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
                          ),
                          Text(
                            "Deskripsi",
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: _textColorDark),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deskripsi,
                           style: GoogleFonts.poppins(
  fontSize: 14,
  height: 1.6,
  color: _textColorDark.withValues(alpha: 0.8),
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
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: _bgColor,
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _primaryColor.withValues(alpha: 0.3), width: 1),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
                  },
                  icon: const Icon(Icons.message_rounded),
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 14),

              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _primaryColor.withValues(alpha: 0.3), width: 1),
                ),
                child: IconButton(
                  onPressed: () => _showKeranjangBottomSheet(context),
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _showSewaBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      "Sewa Sekarang",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}