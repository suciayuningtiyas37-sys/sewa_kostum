import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final TextEditingController nameController =
      TextEditingController(text: "Kez Felice");

  final TextEditingController emailController =
      TextEditingController(text: "admin@gmail.com");

  File? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> changePhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1EB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5C3D2E),
        title: const Text("Admin Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 900),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
               color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Kalau layar lebar (tablet/web) pakai Row, kalau kecil (HP) pakai Column
                bool isWide = constraints.maxWidth > 600;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _avatarSection(),
                          const SizedBox(width: 50),
                          Expanded(child: _formSection()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _avatarSection(),
                          const SizedBox(height: 24),
                          _formSection(),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 65,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
          child: imageFile == null
              ? const Icon(Icons.person, size: 65, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 14),
        ElevatedButton.icon(
          onPressed: changePhoto,
          icon: const Icon(Icons.photo_library),
          label: const Text("Change Photo"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C3D2E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _formSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Name"),
        const SizedBox(height: 6),
        TextField(controller: nameController, decoration: _input()),
        const SizedBox(height: 18),
        _label("Email"),
        const SizedBox(height: 6),
        TextField(controller: emailController, readOnly: true, decoration: _input()),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C3D2E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _input({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
