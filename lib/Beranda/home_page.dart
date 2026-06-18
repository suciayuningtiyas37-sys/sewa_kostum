import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_field.dart';
import 'kostum_list.dart';
import 'kostum_kategori.dart';
import 'keranjang_card.dart';
import 'penyewaan_card.dart';
import 'riwayat_card.dart';
import '../detail/form_sewa.dart';
import 'package:sewa_kostum/Profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 
  String nama = 'Selamat Datang';
  String _selectedKategori = 'All';
  String _searchText = '';

  List<Map<String, dynamic>> daftarKeranjang = [];
  bool isKeranjangLoading = true;

  List<Map<String, dynamic>> daftarPesananAktif = [];
  bool isPenyewaanLoading = true;

  List<Map<String, dynamic>> daftarRiwayat = []; // 🔥 List untuk data riwayat
  bool isRiwayatLoading = true;

  final Color _primaryColor = const Color(0xFF7F5539);
  final Color _textColorDark = const Color(0xFF5C3B2E);
  
  final Color _bgColor = const Color(0xFFFFF6EA); 
  final Color _bgColorPenyewaan = const Color(0xFFFFF6EA);

  @override
  void initState() {
    super.initState();
    _loadNama();
    _loadDataPenyewaan(); 
  }

  Future<void> _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      nama = prefs.getString('name') ?? prefs.getString('nama') ?? 'Selamat Datang';
    });
  }

  void _loadDataPenyewaan() async {
    setState(() => isPenyewaanLoading = true);
    final prefs = await SharedPreferences.getInstance();
    List<String> dataRaw = prefs.getStringList('pesanan') ?? [];

    List<Map<String, dynamic>> tempLoad = [];
    for (var item in dataRaw) {
      try {
        final Map<String, dynamic> pesanan = jsonDecode(item);
        if (pesanan['status_rental'] != 'SELESAI') {
          tempLoad.add(pesanan);
        }
      } catch (_) {}
    }

    setState(() {
      daftarPesananAktif = tempLoad.reversed.toList();
      isPenyewaanLoading = false;
    });
  }

  Future<void> _loadKeranjang() async {
    setState(() => isKeranjangLoading = true);
    final prefs = await SharedPreferences.getInstance();
    List<String> dataRaw = prefs.getStringList('keranjang') ?? [];
    setState(() {
      daftarKeranjang = dataRaw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      isKeranjangLoading = false;
    });
  }

  Future<void> _saveKeranjang() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('keranjang', daftarKeranjang.map((e) => jsonEncode(e)).toList());
  }

  Future<void> _loadRiwayat() async {
    setState(() => isRiwayatLoading = true);
    final prefs = await SharedPreferences.getInstance();
    List<String> dataRaw = prefs.getStringList('riwayat') ?? [];

    setState(() {
      daftarRiwayat = dataRaw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList().reversed.toList();
      isRiwayatLoading = false;
    });
  }

  // FUNGSI MENU POP-UP AUTH (LOGIN / REGISTRASI)
  void _showAuthMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Masuk ke Akun Anda", 
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _textColorDark)
              ),
              const SizedBox(height: 8),
              Text(
                "Silakan login atau daftar untuk mulai menyewa kostum favoritmu.", 
                textAlign: TextAlign.center, 
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)
              ),
              const SizedBox(height: 28),
              
              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pushNamed(context, '/login'); 
                  },
                  child: Text("Login", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              
              // TOMBOL REGISTRASI
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pushNamed(context, '/register'); 
                  },
                  child: Text("Registrasi", style: GoogleFonts.poppins(color: _primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildBerandaContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama == 'Selamat Datang'
                ? 'Halo 👋\nMau sewa kostum apa hari ini?'
                : 'Halo, $nama 👋\nMau sewa kostum apa hari ini?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textColorDark,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 10),

          // LOCATION (SUDAH BENAR)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6EA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF7F5539),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Jl. Kali Abang Tengah No.8, Bekasi Utara",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        } else {
          _showAuthMenu(context);
        }
      },
      borderRadius: BorderRadius.circular(22),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: _primaryColor,
        child: const Icon(Icons.person, color: Colors.white),
      ),
    ),
  ],
),
                const SizedBox(height: 14),
                SearchField(onChanged: (value) { setState(() { _searchText = value; }); }),
                const SizedBox(height: 14),
                KostumKategori(onKategoriSelected: (kategori) { setState(() { _selectedKategori = kategori; }); }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: KostumList(kategori: _selectedKategori, search: _searchText),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPenyewaanContent() {
    return Scaffold(
      backgroundColor: _bgColorPenyewaan,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Penyewaan Aktif Saya", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: isPenyewaanLoading
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : daftarPesananAktif.isEmpty
              ? Center(child: Text("Tidak Ada Baju yang Sedang Disewa", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daftarPesananAktif.length,
                  itemBuilder: (context, index) {
                    return PenyewaanCard(item: daftarPesananAktif[index]);
                  },
                ),
    );
  }

  Widget _buildRiwayatContent() {
  return Scaffold(
    backgroundColor: _bgColor,
    appBar: AppBar(
      title: Text("Riwayat Penyewaan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
    ),
    body: isRiwayatLoading
        ? Center(child: CircularProgressIndicator(color: _primaryColor))
        : daftarRiwayat.isEmpty
            ? Center(child: Text("Belum ada riwayat penyewaan.", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: daftarRiwayat.length,
                itemBuilder: (context, index) {
                  return RiwayatCard(item: daftarRiwayat[index]); // 🔥 Pastikan sudah import 'riwayat_card.dart'
                },
              ),
    );
  }

  Widget _buildKeranjangContent() {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text("Keranjang Saya", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isKeranjangLoading
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : daftarKeranjang.isEmpty
              ? Center(child: Text("Keranjang masih kosong", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textColorDark)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daftarKeranjang.length,
                  itemBuilder: (context, index) {
                    final item = daftarKeranjang[index];
                    return KeranjangCard(
                      item: item,
                      onUpdate: () { setState(() {}); _saveKeranjang(); },
                      onDelete: () { setState(() => daftarKeranjang.removeAt(index)); _saveKeranjang(); },
                      onSewa: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormSewaPage(
                              namaProduk: item["produk"] ?? "Kostum",
                              hargaSatuan: int.tryParse(item["harga"].toString()) ?? 0,
                              fotoProduk: item["foto"] ?? item["fotoProduk"] ?? "assets/img/kebaya.jpg",
                              ukuran: item["ukuran"] ?? "-",
                              jumlah: item["jumlah"] ?? 1,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: _selectedIndex == 0 
          ? SafeArea(child: _buildBerandaContent()) 
          : _selectedIndex == 1
            ? _buildKeranjangContent()
              : _selectedIndex == 2 
                ? _buildPenyewaanContent()
                : _selectedIndex == 3
                  ? _buildRiwayatContent()
                  : Center(child: Text("Halaman Index Ke-$_selectedIndex")),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() { _selectedIndex = index; });
          if (index == 1) {_loadKeranjang(); }  
          if (index == 2) { _loadDataPenyewaan(); }
          if (index == 3) {_loadRiwayat();}
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Penyewaan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}