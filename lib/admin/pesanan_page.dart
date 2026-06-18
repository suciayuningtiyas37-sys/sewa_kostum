import 'package:flutter/material.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list pesanan
    final List<Map<String, dynamic>> pesananList = [
      {
        "nama": "alya",
        "wa": "012345678910",
        "alamat": "bks",
        "kostum": "Kebaya Modern",
        "tanggal_sewa": "18/06/2026", // gunakan underscore biar konsisten
        "durasi": "2 hari",
        "harga": "Rp300.000",
        "status": "Menunggu"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pesanan Masuk"),
        backgroundColor: const Color(0xFFFFF6EA),
        foregroundColor: Color(0xFF4E3B2A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal, // tabel bisa di-scroll
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFFCEFE3)),
          columns: const [
            DataColumn(label: Text("Nama")),
            DataColumn(label: Text("WhatsApp")),
            DataColumn(label: Text("Alamat")),
            DataColumn(label: Text("Kostum")),
            DataColumn(label: Text("Tanggal Sewa")),
            DataColumn(label: Text("Durasi")),
            DataColumn(label: Text("Harga")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: pesananList.map((pesanan) {
            return DataRow(cells: [
              DataCell(Text(pesanan['nama'] ?? "-")),
              DataCell(Text(pesanan['wa'] ?? "-")),
              DataCell(Text(pesanan['alamat'] ?? "-")),
              DataCell(Text(pesanan['kostum'] ?? "-")),
              DataCell(Text(pesanan['tanggal_sewa'] ?? "-")), // konsisten
              DataCell(Text(pesanan['durasi'] ?? "-")),
              DataCell(Text(pesanan['harga'] ?? "-")),
              DataCell(Text(pesanan['status'] ?? "-")),
              DataCell(Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // aksi konfirmasi
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 30),
                    ),
                    child: const Text("Konfirmasi"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // aksi batalkan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 30),
                    ),
                    child: const Text("Batalkan"),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
