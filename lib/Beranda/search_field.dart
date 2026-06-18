import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {

  final Function(String) onChanged;

  const SearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: TextField(

        onChanged: onChanged,

        decoration: const InputDecoration(
          hintText: 'Cari kostum',

          hintStyle: TextStyle(
            color: Colors.grey,
          ),

          border: InputBorder.none,

          icon: Icon(
            Icons.search,
            color: Color(0xFF7F5539),
          ),
        ),
      ),
    );
  }
}