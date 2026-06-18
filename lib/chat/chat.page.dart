import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  void _sendMessage(String text) {
    setState(() {
      messages.add({"role": "user", "text": text});

      if (text.toLowerCase().contains("hallo min")) {
        messages.add({"role": "admin", "text": "Hallo, selamat datang di CosRent!"});
      } else if (text.toLowerCase().contains("apakah kostum ini masih tersedia")) {
        messages.add({"role": "admin", "text": "Iya, kostum ini masih tersedia dan bisa dipesan."});
      } else {
        messages.add({"role": "admin", "text": "Terima kasih, pesan Anda sudah diterima."});
      }
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // beige background

      appBar: AppBar(
        title: Text(
          "Chat Admin",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7F5539),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF7F5539) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: GoogleFonts.poppins(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF7F5539)),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      _sendMessage(controller.text);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
