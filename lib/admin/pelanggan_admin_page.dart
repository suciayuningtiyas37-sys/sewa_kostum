import 'package:flutter/material.dart';

class PelangganAdminPage extends StatelessWidget {
  const PelangganAdminPage({super.key});

  final List<Map<String, String>> pelangganList = const [
    {"nama": "Andi", "telepon": "08123456789"},
    {"nama": "Budi", "telepon": "08234567890"},
    {"nama": "Citra", "telepon": "08345678901"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pengguna"),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFF6EA),
        foregroundColor: const Color(0xFF4E3B2A),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: screenWidth),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFFCEFE3)),
            columnSpacing: 30, // jarak antar kolom
            columns: const [
              DataColumn(label: Text("No")),
              DataColumn(label: Text("Nama")),
              DataColumn(label: Text("No. Telepon")),
            ],
            rows: List.generate(pelangganList.length, (index) {
              final pelanggan = pelangganList[index];
              return DataRow(
                cells: [
                  DataCell(Text("${index + 1}")),
                  DataCell(Text(pelanggan['nama']!)),
                  DataCell(Text(pelanggan['telepon']!)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
