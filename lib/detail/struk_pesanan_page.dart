import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrukPesananPage extends StatefulWidget {
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

  const StrukPesananPage({
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
  State<StrukPesananPage> createState() => _StrukPesananPageState();
}

class _StrukPesananPageState extends State<StrukPesananPage> {
  late final String statusPembayaran;
  late final String idPesanan;
  late final String waktuNota;

  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);

  @override
  void initState() {
    super.initState();
    final bool isOnline = widget.metodeBayar.contains("Online");
    statusPembayaran = isOnline ? "LUNAS" : "BELUM DIBAYAR";
    final String prefix = isOnline ? "QRIS" : "COD";
    idPesanan = "$prefix-${DateTime.now().millisecondsSinceEpoch}";
    
    final now = DateTime.now();
    waktuNota = "${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    _autoSavePesanan();
  }

  Future<void> _autoSavePesanan() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('pesanan') ?? [];

    Map<String, dynamic> data = {
      "idPesanan": idPesanan,
      "nama": widget.nama,
      "wa": widget.wa,
      "alamat": widget.alamat,
      "produk": widget.produk,
      "ukuran": widget.ukuran,
      "harga": widget.harga,
      "hargaSatuan": widget.hargaSatuan,
      "total": widget.totalBayar,
      "metodeBayar": widget.metodeBayar,
      "status": statusPembayaran,
      "waktuPesanan": waktuNota,
      "tanggalSewa": widget.tanggalSewa,
      "jamSewa": widget.jamSewa,
      "tanggalKembali": widget.tanggalKembali,
      "jamKembali": widget.jamKembali,
      "status_rental": "DIPAKAI",
      "fotoProduk": widget.fotoProduk,
      "deposit": widget.deposit,
      "ongkir": widget.ongkir,
      "jumlah": widget.jumlah,
      "biayaOngkirBalik": widget.biayaOngkirBalik,
      "totalHargaKostum": widget.totalHargaKostum,
      "metodePengembalian": widget.metodePengembalian,
    };

    list.add(jsonEncode(data));
    await prefs.setStringList('pesanan', list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, 
        title: Text("Struk Pembelian", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CosRent", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: _primaryColor, letterSpacing: 1)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusPembayaran == "LUNAS" ? Colors.green.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusPembayaran,
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: statusPembayaran == "LUNAS" ? Colors.green : Colors.amber.shade800),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Nota Transaksi Rental Costume", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, thickness: 1)),
                    _buildTextRow(label: "ID Pesanan", value: idPesanan, isBoldValue: true),
                    _buildTextRow(label: "Waktu Pemesanan", value: waktuNota),
                    _buildTextRow(label: "Nama Pelanggan", value: widget.nama),
                    _buildTextRow(label: "No. WhatsApp", value: widget.wa),
                    _buildTextRow(label: "Sistem Pengambilan", value: widget.metodeLayanan == "pickup" ? "Ambil Mandiri di Toko" : "Diantar Driver (GoRent)"),
                    _buildTextRow(label: "Sistem Pengembalian", value: widget.metodePengembalian == "pickup" ? "Antar Mandiri di Toko" : "Diambil Driver (GoRent)"),
                    const SizedBox(height: 4),
                    Text("Alamat Pengiriman:", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(widget.alamat, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _textColorDark, height: 1.3)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, thickness: 1)),
                    Text("Detail Sewa", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    _buildTextRow(label: "Durasi Sewa", value: "${widget.tanggalSewa} s/d ${widget.tanggalKembali}"),
                    _buildTextRow(label: "Waktu Operasional", value: "${widget.jamSewa} - ${widget.jamKembali}"),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, thickness: 1)),
                    Text("Item Costume", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(widget.produk, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark))),
                        Text("Rp ${widget.totalHargaKostum}", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: _textColorDark)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, thickness: 1)),
                    _buildTextRow(label: "Metode Pembayaran", value: widget.metodeBayar),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Tagihan", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)),
                        Text("Rp ${widget.totalBayar}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: _primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // 🔥 BALIK BERSIH: Memangkas tumpukan stack navigasi kembali ke halaman dasar paling pertama
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Selesai & Kembali", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextRow({required String label, required String value, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(width: 16),
          Expanded(child: Text(value, textAlign: TextAlign.end, style: GoogleFonts.poppins(fontSize: 13, fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600, color: _textColorDark))),
        ],
      ),
    );
  }
}