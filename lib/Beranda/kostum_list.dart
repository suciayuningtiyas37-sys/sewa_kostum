import 'package:flutter/material.dart';
import 'kostum_card.dart';

class KostumList extends StatelessWidget {
  final String kategori;
  final String search;

  const KostumList({
    super.key,
    required this.kategori,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Diubah menjadi dynamic agar bisa menyimpan Map stok di dalamnya
    final List<Map<String, dynamic>> costumes = [
      {
        'nama': 'Kebaya Modern',
        'harga': 'Rp 150k',
        'foto': 'assets/img/kebaya.jpg',
        'kategori': 'Kebaya',
        'deskripsi': 'Kebaya modern elegan cocok untuk acara formal.',
        'stok': {'S': 3, 'M': 5, 'L': 0, 'XL': 2}, // 🔥 Data stok ditambahkan di sini
      },
      {
        'nama': 'Kebaya Brokat',
        'harga': 'Rp 180k',
        'foto': 'assets/img/kebaya 2.jpg',
        'kategori': 'Kebaya',
        'deskripsi': 'Kebaya brokat mewah dengan desain feminin.',
        'stok': {'S': 2, 'M': 4, 'L': 1, 'XL': 0},
      },
      {
        'nama': 'Baju Adat Jawa',
        'harga': 'Rp 200k',
        'foto': 'assets/img/baju adat.jpg',
        'kategori': 'Baju Adat',
        'deskripsi': 'Baju adat Jawa lengkap dan nyaman digunakan.',
        'stok': {'S': 1, 'M': 3, 'L': 2, 'XL': 1},
      },
      {
        'nama': 'Baju Adat Couple',
        'harga': 'Rp 250k',
        'foto': 'assets/img/baju adat 2.jpg',
        'kategori': 'Baju Adat',
        'deskripsi': 'Baju adat couple elegan untuk pasangan.',
        'stok': {'S': 0, 'M': 2, 'L': 2, 'XL': 0},
      },
      {
        'nama': 'Cosplay Anime',
        'harga': 'Rp 220k',
        'foto': 'assets/img/cosplay.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum cosplay anime keren dan detail.',
        'stok': {'S': 4, 'M': 4, 'L': 3, 'XL': 2},
      },
      {
        'nama': 'Cosplay Witch',
        'harga': 'Rp 240k',
        'foto': 'assets/img/cosplay 2.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum witch aesthetic cocok untuk event.',
        'stok': {'S': 2, 'M': 2, 'L': 1, 'XL': 1},
      },
      {
        'nama': 'Cosplay Pocong',
        'harga': 'Rp 200k',
        'foto': 'assets/img/pocong.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum pocong seram untuk acara halloween.',
        'stok': {'S': 5, 'M': 5, 'L': 5, 'XL': 5},
      },
      {
        'nama': 'Cosplay Alien',
        'harga': 'Rp 140k',
        'foto': 'assets/img/alien.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum alien unik dengan desain futuristik.',
        'stok': {'S': 1, 'M': 2, 'L': 0, 'XL': 0},
      },
      {
        'nama': 'Cosplay Conjuring',
        'harga': 'Rp 250k',
        'foto': 'assets/img/conjuring.jpg',
        'kategori': 'Cosplay',
        'deskripsi': 'Kostum horror conjuring dengan tampilan menyeramkan.',
        'stok': {'S': 2, 'M': 1, 'L': 1, 'XL': 0},
      },
      {
        'nama': 'Profesi Polisi',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 1.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum profesi polisi lucu untuk anak-anak.',
        'stok': {'S': 3, 'M': 3, 'L': 2, 'XL': 1},
      },
      {
        'nama': 'Profesi Dokter',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 2.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum dokter anak lengkap dan nyaman.',
        'stok': {'S': 4, 'M': 4, 'L': 2, 'XL': 2},
      },
      {
        'nama': 'Profesi Damkar',
        'harga': 'Rp 200k',
        'foto': 'assets/img/profesi anak 3.jpg',
        'kategori': 'Profesi Anak',
        'deskripsi': 'Kostum damkar anak keren untuk pentas sekolah.',
        'stok': {'S': 2, 'M': 3, 'L': 3, 'XL': 1},
      },
    ];

    // FILTER KATEGORI + SEARCH
    final filteredCostumes = costumes.where((item) {
      final cocokKategori = kategori == 'All' || item['kategori'] == kategori;
      final cocokSearch = search.isEmpty ||
          item['nama']!.toLowerCase().contains(search.toLowerCase());
      return cocokKategori && cocokSearch;
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16), // Disesuaikan dengan layout beranda
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredCostumes.length,
      itemBuilder: (context, index) {
        final item = filteredCostumes[index];
        return KostumCard(
          nama: item['nama']!,
          harga: item['harga']!,
          foto: item['foto']!,
          deskripsi: item['deskripsi']!,
          stok: Map<String, int>.from(item['stok']), // 🔥 Lempar data stok ke KostumCard
        );
      },
    );
  }
}