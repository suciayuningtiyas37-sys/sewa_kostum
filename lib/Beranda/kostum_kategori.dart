import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KostumKategori extends StatelessWidget {
  final Function(String) onKategoriSelected;

  const KostumKategori({
    super.key,
    required this.onKategoriSelected,
  });

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> categories = [

      {
        'nama': 'All',
        'icon': Icons.apps,
        'color': const Color(0xFFFFF6EA),
      },

      {
        'nama': 'Kebaya',
        'icon': Icons.checkroom,
        'color': const Color(0xFFFFF6EA),
      },

      {
        'nama': 'Baju Adat',
        'icon': Icons.fort_outlined,
        'color': const Color(0xFFFFF6EA),
      },

      {
        'nama': 'Cosplay',
        'icon': Icons.face_retouching_natural,
        'color': const Color(0xFFFFF6EA),
      },

      {
        'nama':'Profesi Anak',
        'icon':Icons.badge,
        'color':const Color(0xFFFFF6EA),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        // ===== HEADER =====
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Text(
                'Kategori',

                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7F5539),
                ),
              ),

              Text(
                'Lihat Semua',

                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFB08968),
                ),
              ),
            ],
          ),
        ),

        // ===== LIST BUTTON =====
        SizedBox(
          height: 110,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            itemCount: categories.length,

            separatorBuilder: (context, index) =>
                const SizedBox(width: 12),

            itemBuilder: (context, index) {

              final kategori = categories[index];

              return InkWell(
                onTap: () {
                  onKategoriSelected(
                    kategori['nama'],
                  );
                },

                borderRadius:
                    BorderRadius.circular(22),

                child: Container(
                  width: 90,

                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 10,
                  ),

                  decoration: BoxDecoration(
                    color: kategori['color'],

                    borderRadius:
                        BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),


                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Icon(
                        kategori['icon'],
                        color:
                            const Color(0xFF7F5539),

                        size: 30,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        kategori['nama'],

                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}