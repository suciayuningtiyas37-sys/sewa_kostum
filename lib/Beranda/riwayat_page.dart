import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    // sementara masih dummy data
    final List<Map<String, String>> riwayat = [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),

      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
        backgroundColor: const Color(0xFF7F5539),
      ),

      body: riwayat.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat pesanan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                final item = riwayat[index];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      item['status'] == 'LUNAS'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: item['status'] == 'LUNAS'
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(item['id'] ?? '-'),
                    subtitle: Text(
                      "${item['produk']} - ${item['status']}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}