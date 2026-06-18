import 'package:flutter/material.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() => _ProdukAdminPageState();
}

class _ProdukAdminPageState extends State<ProdukAdminPage> {
  List<Map<String, dynamic>> produkList = [

     {
        'nama': 'Kebaya Modern',
        'harga': 'Rp 150k',
        'foto': 'assets/img/kebaya.jpg',
        'kategori': 'Kebaya',
        'deskripsi': 'Kebaya modern elegan cocok untuk acara formal.',
        'stok': '2',
      },
      {
        'nama': 'Kebaya Brokat',
        'harga': 'Rp 180k',
        'foto': 'assets/img/kebaya 2.jpg',
        'kategori': 'Kebaya',
        'deskripsi': 'Kebaya brokat mewah dengan desain feminin.',
        'stok': '3',
      },
      {
        'nama': 'Baju Adat Jawa',
        'harga': 'Rp 200k',
        'foto': 'assets/img/baju adat.jpg',
        'kategori': 'Baju Adat',
        'deskripsi': 'Baju adat Jawa lengkap dan nyaman digunakan.',
        'stok': '4',
      },
      {
        'nama': 'Baju Adat Couple',
        'harga': 'Rp 250k',
        'foto': 'assets/img/baju adat 2.jpg',
        'kategori': 'Baju Adat',
        'deskripsi': 'Baju adat couple elegan untuk pasangan.',
        'stok': '5',
      },
      {
        'nama': 'Cosplay Anime',
        'harga': 'Rp 220k',
        'foto': 'assets/img/cosplay.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum cosplay anime keren dan detail.',
        'stok': '6',
      },
      {
        'nama': 'Cosplay Witch',
        'harga': 'Rp 240k',
        'foto': 'assets/img/cosplay 2.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum witch aesthetic cocok untuk event.',
        'stok': '7',
      },
      {
        'nama': 'Cosplay Pocong',
        'harga': 'Rp 200k',
        'foto': 'assets/img/pocong.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum pocong seram untuk acara halloween.',
        'stok': '3',
      },
      {
        'nama': 'Cosplay Alien',
        'harga': 'Rp 140k',
        'foto': 'assets/img/alien.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum alien unik dengan desain futuristik.',
        'stok': '4',
      },
      {
        'nama': 'Cosplay Conjuring',
        'harga': 'Rp 250k',
        'foto': 'assets/img/conjuring.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum horror conjuring dengan tampilan menyeramkan.',
        'stok': '3',
      },
      {
        'nama': 'Profesi Polisi',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 1.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum profesi polisi lucu untuk anak-anak.',
        'stok': '4',
      },
      {
        'nama': 'Profesi Dokter',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 2.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum dokter anak lengkap dan nyaman.',
        'stok': '5',
      },
      {
        'nama': 'Profesi Damkar',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 3.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum damkar anak keren untuk pentas sekolah.',
        'stok':'4',
      },
  ];

  void _showForm({Map<String, dynamic>? produk, int? index}) {
    final namaController = TextEditingController(text: produk?['nama'] ?? "");
    final kategoriController = TextEditingController(text: produk?['kategori'] ?? "");
    final hargaController = TextEditingController(text: produk?['harga'] ?? "");
    final stokController = TextEditingController(text: produk?['stok']?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(produk == null ? "Tambah Produk" : "Edit Produk"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: namaController, decoration: const InputDecoration(labelText: "Nama Kostum")),
              TextField(controller: kategoriController, decoration: const InputDecoration(labelText: "Kategori")),
              TextField(controller: hargaController, decoration: const InputDecoration(labelText: "Harga")),
              TextField(controller: stokController, decoration: const InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final newProduk = {
                "nama": namaController.text,
                "kategori": kategoriController.text,
                "harga": hargaController.text,
                "stok": int.tryParse(stokController.text) ?? 0,
                "foto": produk?['foto'] ?? "assets/img/default.jpg",
              };
              setState(() {
                if (produk == null) {
                  produkList.add(newProduk);
                } else {
                  produkList[index!] = newProduk;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Produk"),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFF6EA),
        foregroundColor: Color(0xFF4E3B2A),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: produkList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final produk = produkList[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                produk['foto'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(produk['nama']),
            subtitle: Text("${produk['kategori']} • ${produk['harga']} • Stok: ${produk['stok']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(produk: produk, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      produkList.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7F5539),
        foregroundColor: Colors.white,
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
