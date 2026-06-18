import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'struk_pesanan_page.dart';
import 'barcode_pembayaran_page.dart'; // 🔥 Pastikan file barcode_pembayaran_page.dart sudah dibuat

class MetodePembayaranPage extends StatefulWidget {
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
  final String fotoProduk;
  final int jumlah;
  final int biayaOngkirBalik;
  final int totalHargaKostum;

  const MetodePembayaranPage({
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
    required this.fotoProduk,
    required this.jumlah,
    required this.biayaOngkirBalik,
    required this.totalHargaKostum,
  });

  @override
  State<MetodePembayaranPage> createState() => _MetodePembayaranPageState();
}

class _MetodePembayaranPageState extends State<MetodePembayaranPage> {
  String? metodeBayar;

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  @override
  Widget build(BuildContext context) {
    int ongkir = widget.metodeLayanan == "gorent" ? 20000 : 0;
    int biayaOngkirBalik = widget.metodePengembalian == "gorent" ? 20000 : 0;
    int deposit = (widget.harga * 0.5).round(); // Jaminan kostum
    int total = widget.totalHargaKostum + ongkir + deposit + biayaOngkirBalik;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Pembayaran", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD RINGKASAN WAKTU SEWA
            _buildSectionTitle("Detail Waktu Sewa"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pengambilan", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                        Text("${widget.tanggalSewa} • ${widget.jamSewa}", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _textColorDark)),
                      ],
                    ),
                  ),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pengembalian", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                        Text("${widget.tanggalKembali} • ${widget.jamKembali}", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _textColorDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD RINCIAN BIAYA
            _buildSectionTitle("Rincian Biaya"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildPriceRow(label: "Harga Sewa (${widget.totalHargaKostum})", price: widget.totalHargaKostum),
                  _buildPriceRow(label: "Biaya Layanan (${widget.metodeLayanan == 'pickup' ? 'Ambil Toko' : 'GoRent Driver'})", price: ongkir),
                  _buildPriceRow(label: "Biaya Pengembalian (${widget.metodePengembalian == 'pickup' ? 'Antar Ke Toko' : 'GoRent Driver'})", price: biayaOngkirBalik),
                  _buildPriceRow(label: "Jaminan Garansi Deposit (Refundable)", price: deposit),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 1, color: Color(0xFFF2E6D9)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Pembayaran", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)),
                      Text("Rp $total", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SELEKSI METODE PEMBAYARAN
            _buildSectionTitle("Pilih Metode Pembayaran"),
            Row(
              children: [
                _buildMethodCard(
                  title: "Bayar Sekarang",
                  subtitle: "Instant via QRIS/Transfer",
                  icon: Icons.qr_code_scanner_rounded,
                  value: "Bayar Sekarang",
                ),
                const SizedBox(width: 12),
                _buildMethodCard(
                  title: "Bayar di Tempat",
                  subtitle: "Cash on Delivery (COD)",
                  icon: Icons.payments_rounded,
                  value: "Bayar di Tempat",
                ),
              ],
            ),
            const SizedBox(height: 40),

            // TOMBOL PROSES
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (metodeBayar == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.redAccent, content: Text("Pilih metode pembayaran terlebih dahulu", style: GoogleFonts.poppins())),
                    );
                    return;
                  }

                  // 🔥 FIX LOGIKA PERCABANGAN HALAMAN
                  if (metodeBayar == "Bayar Sekarang") {
                    // Alur Ke Barcode dulu untuk "Bayar Sekarang"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodePembayaranPage(
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
                          metodeBayar: "Online (QRIS)",
                          totalBayar: total,
                          fotoProduk: "${widget.fotoProduk}",
                          deposit: deposit,
                          ongkir: ongkir,
                          jumlah: widget.jumlah,
                          biayaOngkirBalik: widget.biayaOngkirBalik,
                          totalHargaKostum: widget.totalHargaKostum,
                        ),
                      ),
                    );
                  } else {
                    // Langsung ke Struk Invoice untuk "Bayar di Tempat (COD)"
                    Navigator.push(
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
                          metodeBayar: "Bayar di Tempat (COD)",
                          totalBayar: total,
                          fotoProduk: "${widget.fotoProduk}",
                          deposit: deposit,
                          ongkir: ongkir,
                          jumlah: widget.jumlah,
                          biayaOngkirBalik: widget.biayaOngkirBalik,
                          totalHargaKostum: widget.totalHargaKostum,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Konfirmasi & Selesaikan Transaksi",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryColor)),
    );
  }

  Widget _buildPriceRow({required String label, required int price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
          Text(price == 0 ? "Gratis" : "Rp $price", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _textColorDark)),
        ],
      ),
    );
  }

  Widget _buildMethodCard({required String title, required String subtitle, required IconData icon, required String value}) {
    bool isSelected = metodeBayar == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => metodeBayar = value),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? _primaryColor : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: isSelected ? _primaryColor : Colors.grey, size: 24),
              const SizedBox(height: 12),
              Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _textColorDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }
}