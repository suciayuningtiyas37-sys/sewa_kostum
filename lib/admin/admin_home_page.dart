import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'admin_profile_page.dart';
import 'pesanan_page.dart';
import 'produk_admin_page.dart';
import 'kategori_admin_page.dart';
import 'pelanggan_admin_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<String> _menuTitles = [
    "Dashboard",
    "Pesanan Masuk",
    "Produk",
    "Kategori",
    "Data Pelanggan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.checkroom, color: Colors.white, size: 28),
        ),
        title: const Text(
          "CosRent",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF7F5539),
        elevation: 0,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF7F5539)),
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 80, 10, 0),
                items: const [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF7F5539)),
                        SizedBox(width: 10),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminProfilePage(),
                    ),
                  );
                }
                if (value == 'logout') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Yakin ingin keluar dari admin?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                           Navigator.pop(context); // tutup dialog
                          Navigator.pushReplacementNamed(context, '/admin_login');
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xFFFCEFE3),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: const TextStyle(
              color: Color(0xFF7F5539),
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: const TextStyle(color: Color(0xFF7F5539)),
            selectedIconTheme: const IconThemeData(color: Color(0xFF7F5539)),
            unselectedIconTheme: const IconThemeData(color: Color(0xFF7F5539)),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text("Dashboard"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                label: Text("Pesanan"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory),
                label: Text("Produk"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category),
                label: Text("Kategori"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text("Pelanggan"),
              ),
            ],
          ),
          Expanded(child: _buildPage(_selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const PesananPage();
      case 2:
        return const ProdukAdminPage();
      case 3:
        return const KategoriAdminPage();
      case 4:
        return const PelangganAdminPage();
      default:
        return Center(
          child: Text(
            "Halaman: ${_menuTitles[index]}",
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF7F5539),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
