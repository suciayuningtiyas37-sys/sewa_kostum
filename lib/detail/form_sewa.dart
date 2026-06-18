import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metode_pembayaran_page.dart'; // Mengarahkan import ke halaman metode pembayaran
import 'package:sewa_kostum/Welcome/Login_page.dart';

class FormSewaPage extends StatefulWidget {
  // 🔥 SEKARANG DINAMIS: Menerima data kostum langsung dari halaman Syarat Sewa
  final String namaProduk;
  final int hargaSatuan;
  final String fotoProduk;
  final String ukuran;
  final int jumlah;

  const FormSewaPage({
    super.key,
    required this.namaProduk,
    required this.hargaSatuan,
    required this.fotoProduk,
    required this.ukuran,
    required this.jumlah,
  });

  @override
  State<FormSewaPage> createState() => _FormSewaPageState();
}

class _FormSewaPageState extends State<FormSewaPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _waController = TextEditingController();
  final _alamatDetailController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kodePosController = TextEditingController(); 

  String metodeLayanan = "pickup";
  int durasi = 1;

  String metodePengembalian = "pickup"; // Default
  int biayaPengembalian = 0;

  DateTime? selectedDate;
  DateTime? returnDate;

  TimeOfDay? selectedTime;
  TimeOfDay? returnTime;

  // Palette Warna Konsisten CosRent
  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  final Color _bgColor = const Color(0xFFFFF6EA);
  final Color _accentColor = const Color(0xFFD4A373);

  bool get isIncomplete =>
      selectedDate == null ||
      returnDate == null ||
      selectedTime == null ||
      returnTime == null;

  // 🔥 LOGIKA HITUNG TOTAL HARGA OTOMATIS BERDASARKAN PARAMETER KOSTUM
  int get totalHargaKostum => widget.hargaSatuan * widget.jumlah * durasi;
  int get biayaOngkir => metodeLayanan == "gorent" ? 20000 : 0;
  int get biayaOngkirBalik => metodePengembalian == "gorent" ? 20000 : 0;
  int get totalKeseluruhan => totalHargaKostum + biayaOngkir + biayaOngkirBalik;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkLogin();
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> _checkLogin() async {
    final login = await _isLoggedIn();
    if (!login) {
      Future.microtask(() {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _namaController.text = prefs.getString('nama') ?? prefs.getString('name') ?? '';
    _waController.text = prefs.getString('phone') ?? prefs.getString('wa') ?? '';
    _alamatDetailController.text = prefs.getString('alamat_detail') ?? '';
    _kecamatanController.text = prefs.getString('kecamatan') ?? '';
    _kelurahanController.text = prefs.getString('kelurahan') ?? '';
    _kodePosController.text = prefs.getString('kode_pos') ?? '';

    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nama', _namaController.text.trim());
    await prefs.setString('name', _namaController.text.trim());
    await prefs.setString('wa', _waController.text.trim());
    await prefs.setString('phone', _waController.text.trim());
    await prefs.setString('alamat_detail', _alamatDetailController.text.trim());
    await prefs.setString('kecamatan', _kecamatanController.text.trim());
    await prefs.setString('kelurahan', _kelurahanController.text.trim());
    await prefs.setString('kode_pos', _kodePosController.text.trim());
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();

    final pickedRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 520,
            child: Theme(
              data: Theme.of(context).copyWith(
                scaffoldBackgroundColor: Colors.white,
                textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                colorScheme: ColorScheme.light(
                  primary: _primaryColor, 
                  onPrimary: Colors.white, 
                  secondary: _accentColor,
                  surface: Colors.white, 
                  onSurface: _textColorDark, 
                ),
              ),
              child: DateRangePickerDialog(
                firstDate: now,
                lastDate: now.add(const Duration(days: 30)),
                currentDate: now,
                confirmText: "PILIH",
                cancelText: "BATAL",
                helpText: "PILIH TANGGAL SEWA",
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDateRange: selectedDate != null && returnDate != null
                    ? DateTimeRange(start: selectedDate!, end: returnDate!)
                    : null,
              ),
            ),
          ),
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        selectedDate = pickedRange.start;
        returnDate = pickedRange.end;
        durasi = returnDate!.difference(selectedDate!).inDays + 1;
      });
    }
  }

  Future<void> _pickTimeAmbil() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: _primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: _textColorDark,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _pickReturnTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: _primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: _textColorDark,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) setState(() => returnTime = picked);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.redAccent, content: Text(message, style: GoogleFonts.poppins())),
    );
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon, String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: GoogleFonts.poppins(color: _textColorDark.withValues(alpha: 0.6)),
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icon, color: _primaryColor, size: 20),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: _primaryColor),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildSelectorTile({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
           color: _bgColor.withValues(alpha: 0.3),
          ),
          child: Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _textColorDark)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Form Sewa Kostum", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // 🔥 1. CARD PREVIEW DATA KOSTUM YANG DI SEWA (Bukan Dummy Lagi)
                _buildSectionTitle("Detail Kostum yang Disewa"),
                _buildCardContainer(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.fotoProduk, 
                            width: 70, 
                            height: 70, 
                            fit: BoxFit.cover,
                            errorBuilder: (_,__,___) => const Icon(Icons.checkroom, size: 50, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.namaProduk, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: _textColorDark)),
                              const SizedBox(height: 4),
                              Text("Ukuran: ${widget.ukuran}  |  Qty: ${widget.jumlah} pcs", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700)),
                              const SizedBox(height: 4),
                              Text("Rp ${widget.hargaSatuan} / hari", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 2. CARD DATA PENYEWA
                _buildSectionTitle("Data Diri Penyewa"),
                _buildCardContainer(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Nama Lengkap", icon: Icons.person_outline_rounded),
                      validator: (v) => v == null || v.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _waController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Nomor WhatsApp", icon: Icons.phone_android_rounded),
                      validator: (v) => v == null || v.isEmpty ? "Nomor WhatsApp wajib diisi" : null,
                    ),
                  ],
                ),

                // 3. CARD ALAMAT
                _buildSectionTitle("Alamat Tujuan Pengiriman"),
                _buildCardContainer(
                  children: [
                    TextFormField(
                      controller: _alamatDetailController,
                      maxLines: 2,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Alamat Lengkap & Detail Jalan", icon: Icons.home_work_outlined),
                      validator: (v) => v == null || v.isEmpty ? "Alamat detail wajib diisi" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _kecamatanController,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Kecamatan", icon: Icons.map_outlined),
                      validator: (v) => v == null || v.isEmpty ? "Kecamatan wajib diisi" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _kelurahanController,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Kelurahan / Desa", icon: Icons.location_city_rounded),
                      validator: (v) => v == null || v.isEmpty ? "Kelurahan wajib diisi" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _kodePosController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _buildInputDecoration(label: "Kode Pos", icon: Icons.local_post_office_outlined),
                      validator: (v) => v == null || v.isEmpty ? "Kode pos wajib diisi" : null,
                    ),
                  ],
                ),

                // 4. CARD DURASI SEWA
                _buildSectionTitle("Durasi & Batas Waktu Sewa"),
                _buildCardContainer(
                  children: [
                    Row(
                      children: [
                        _buildSelectorTile(
                          title: "Tanggal Ambil",
                          subtitle: selectedDate == null ? "Pilih Tanggal" : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          icon: Icons.calendar_today_rounded,
                          onTap: _pickDateRange, 
                        ),
                        const SizedBox(width: 10),
                        _buildSelectorTile(
                          title: "Tanggal Kembali",
                          subtitle: returnDate == null ? "Pilih Tanggal" : "${returnDate!.day}/${returnDate!.month}/${returnDate!.year}",
                          icon: Icons.event_available_rounded,
                          onTap: _pickDateRange, 
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSelectorTile(
                          title: "Jam Ambil",
                          subtitle: selectedTime == null ? "Pilih Jam" : formatTime(selectedTime),
                          icon: Icons.access_time_rounded,
                          onTap: _pickTimeAmbil,
                        ),
                        const SizedBox(width: 10),
                        _buildSelectorTile(
                          title: "Jam Kembali",
                          subtitle: returnTime == null ? "Pilih Jam" : formatTime(returnTime),
                          icon: Icons.alarm_on_rounded,
                          onTap: _pickReturnTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: Colors.grey.shade100, thickness: 1),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Durasi Sewa:", style: GoogleFonts.poppins(fontSize: 13, color: _textColorDark.withValues(alpha: 0.7))),
                        Text("$durasi Hari", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: _primaryColor)),
                      ],
                    )
                  ],
                ),

                // 5. CARD METODE LAYANAN
                _buildSectionTitle("Metode Pengambilan"),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: SegmentedButton<String>(
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: _primaryColor,
                      selectedForegroundColor: Colors.white,
                      foregroundColor: _textColorDark,
                      side: BorderSide(color: _primaryColor.withValues(alpha: 0.3)),
                    ),
                    segments: const [
                      ButtonSegment(value: "pickup", label: Text("Ambil di Toko", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                      ButtonSegment(value: "gorent", label: Text("Antar Driver (+20k)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                    ],
                    selected: {metodeLayanan},
                    onSelectionChanged: (newSelection) {
                      setState(() => metodeLayanan = newSelection.first);
                    },
                  ),
                ),

                _buildSectionTitle("Metode Pengembalian"),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: SegmentedButton<String>(
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: _primaryColor,
                      selectedForegroundColor: Colors.white,
                      foregroundColor: _textColorDark,
                      side: BorderSide(color: _primaryColor.withValues(alpha: 0.3)),
                    ),
                    segments: const [
                      ButtonSegment(value: "pickup", label: Text("Antar Ke Toko", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                      ButtonSegment(value: "gorent", label: Text("Diambil Driver (+20k)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                    ],
                    selected: {metodePengembalian},
                    onSelectionChanged: (newSelection) {
                      setState(() => metodePengembalian = newSelection.first);
                    },
                  ),
                ),

                // 🔥 AREA ESTIMASI TOTAL BIAYA YANG REALISTIS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Biaya Sementara", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)),
                      Text("Rp $totalKeseluruhan", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryColor)),
                    ],
                  ),
                ),

                // 6. TOMBOL SUBMIT (MENGARAHKAN KE METODE PEMBAYARAN SECARA DINAMIS)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      
                      if (isIncomplete) {
                        _showSnackBar("Silakan lengkapi pilihan tanggal dan jam sewa");
                        return;
                      }

                      await _saveData();

                      final detailJalan = _alamatDetailController.text.trim();
                      final kel = _kelurahanController.text.trim();
                      final kec = _kecamatanController.text.trim();
                      final pos = _kodePosController.text.trim();
                      final alamatLengkap = "$detailJalan\nKel. $kel, Kec. $kec\nKode Pos: $pos";

                      if (!mounted) return;

                      // 🔥 DATA DIKIRIM DINAMIS KE HALAMAN METODE PEMBAYARAN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MetodePembayaranPage(
                            nama: _namaController.text.trim(),
                            wa: _waController.text.trim(),
                            alamat: alamatLengkap,
                            produk: "${widget.namaProduk} (${widget.ukuran})",
                            harga: totalKeseluruhan,
                            hargaSatuan: widget.hargaSatuan,
                            ukuran: widget.ukuran,
                            metodeLayanan: metodeLayanan,
                            metodePengembalian: metodePengembalian,
                            tanggalSewa: "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            jamSewa: formatTime(selectedTime),
                            tanggalKembali: "${returnDate!.day}/${returnDate!.month}/${returnDate!.year}",
                            jamKembali: formatTime(returnTime),
                            fotoProduk: "${widget.fotoProduk}",
                            jumlah: widget.jumlah,
                            biayaOngkirBalik: biayaOngkirBalik,
                            totalHargaKostum: totalHargaKostum,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Lanjutkan Pembayaran",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}