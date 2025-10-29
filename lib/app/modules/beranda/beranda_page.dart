import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    final List<Map<String, String>> staffList = [
      {"nama": "Budi Santoso", "jabatan": "Guru Matematika"},
      {"nama": "Siti Rahmawati", "jabatan": "Guru Bahasa Indonesia"},
      {"nama": "Andi Pratama", "jabatan": "Guru IPA"},
      {"nama": "Lestari Wulandari", "jabatan": "Guru IPS"},
      {"nama": "Rina Kartika", "jabatan": "Guru Bahasa Inggris"},
      {"nama": "Dedi Suhendra", "jabatan": "Guru PJOK"},
      {"nama": "Fitri Ananda", "jabatan": "Guru Seni Budaya"},
      {"nama": "Agus Saputra", "jabatan": "Guru PPKn"},
      {"nama": "Nanda Amelia", "jabatan": "Guru Agama"},
      {"nama": "Rafi Maulana", "jabatan": "Guru TIK"},
      {"nama": "Dewi Lestari", "jabatan": "Staf Administrasi"},
      {"nama": "Fajar Nugroho", "jabatan": "Staf Keuangan"},
      {"nama": "Indah Permata", "jabatan": "Pustakawan"},
      {"nama": "Roni Hidayat", "jabatan": "Petugas Kebersihan"},
      {"nama": "Taufik Rahman", "jabatan": "Satpam"},
    ];

    final List<Map<String, dynamic>> programUnggulan = [
      {"icon": Icons.sports_volleyball, "nama": "Bola Voli"},
      {"icon": Icons.emoji_people, "nama": "Pramuka"},
      {"icon": Icons.sports_soccer, "nama": "Futsal"},
      {"icon": Icons.sports_tennis, "nama": "Badminton"},
      {"icon": Icons.sports_kabaddi, "nama": "Sepak Takraw"},
      {"icon": Icons.sports_basketball, "nama": "Basket"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'SMPN 1 KOTA JAMBI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3C72),
        elevation: 1,
        actions: [
          Obx(() => authService.isLoggedIn.value
              ? IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF1E3C72)),
            onPressed: () {
              Get.toNamed('/home');
            },
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kepalaSekolahCard(),
            const SizedBox(height: 24),
            const Text(
              'Prestasi Sekolah',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1E3C72),
              ),
            ),
            const SizedBox(height: 12),
            _prestasiCard(
              icon: Icons.sports_soccer,
              title: 'Tim Futsal SMPN 1 Kota Jambi',
              description:
              'Juara 1 Turnamen Futsal Antar SMP se-Kota Jambi tahun 2024. Prestasi luar biasa yang mengharumkan nama sekolah.',
              color: Colors.blue.shade50,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 16),
            _prestasiCard(
              icon: Icons.menu_book,
              title: 'Prestasi Tahfidz Qur\'an',
              description:
              'Siswa SMPN 1 Kota Jambi menjuarai lomba Tahfidz 5 Juz tingkat provinsi tahun 2024, menjadi inspirasi bagi siswa lain.',
              color: Colors.green.shade50,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Program Unggulan Sekolah',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1E3C72),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: programUnggulan.map((program) {
                return _programCard(program["icon"], program["nama"]);
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Guru & Staf SMPN 1 Kota Jambi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1E3C72),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ExpansionTile(
                leading: const Icon(Icons.group, color: Color(0xFF1E3C72)),
                title: const Text(
                  "Guru dan Staf SMPN 1 Kota Jambi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: staffList.map((staff) {
                  return ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: Colors.blueAccent),
                    title: Text(staff["nama"]!,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(staff["jabatan"]!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E3C72),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed('/login');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
      ),
    );
  }

  Widget _kepalaSekolahCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.person, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'KEPALA SEKOLAH',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1E3C72)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ibu Sri adalah kepala sekolah yang dikenal dengan kepemimpinan inspiratif dan dedikasi tinggi terhadap pendidikan di SMPN 1 Kota Jambi.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prestasiCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration:
              BoxDecoration(color: iconColor, shape: BoxShape.circle),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E3C72))),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _programCard(IconData icon, String nama) {
    return Container(
      width: 165,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A5298), Color(0xFF1E3C72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 6, offset: Offset(2, 3))
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          const SizedBox(height: 8),
          Text(
            nama,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
