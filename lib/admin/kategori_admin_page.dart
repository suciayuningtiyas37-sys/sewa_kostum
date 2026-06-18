import 'package:flutter/material.dart';

class KategoriAdminPage extends StatefulWidget {
  const KategoriAdminPage({super.key});

  @override
  State<KategoriAdminPage> createState() => _KategoriAdminPageState();
}

class _KategoriAdminPageState extends State<KategoriAdminPage> {
  // Dummy data kategori (nama + jumlah produk)
  List<Map<String, dynamic>> kategoriList = [
    {"nama": "Kebaya", "jumlah": 5},
    {"nama": "Baju Adat", "jumlah": 9},
    {"nama": "Cosplay", "jumlah": 23},
    {"nama": "Profesi Anak", "jumlah": 13},
  ];

  void _showForm({Map<String, dynamic>? kategori, int? index}) {
    final namaController = TextEditingController(text: kategori?['nama'] ?? "");
    final jumlahController =
        TextEditingController(text: kategori?['jumlah']?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(kategori == null ? "Tambah Kategori" : "Edit Kategori"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Kategori"),
            ),
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(labelText: "Jumlah Produk"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final newKategori = {
                "nama": namaController.text,
                "jumlah": int.tryParse(jumlahController.text) ?? 0,
              };
              setState(() {
                if (kategori == null) {
                  kategoriList.add(newKategori);
                } else {
                  kategoriList[index!] = newKategori;
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
        title: const Text("Manajemen Kategori"),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFF6EA),
        foregroundColor: const Color(0xFF4E3B2A),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kategoriList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final kategori = kategoriList[index];
          return ListTile(
            title: Text(kategori['nama']),
            subtitle: Text("Jumlah Produk: ${kategori['jumlah']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(kategori: kategori, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      kategoriList.removeAt(index);
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
