import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = Get.find<AuthService>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nipController = TextEditingController();
  final nisnController = TextEditingController();
  String? selectedRole;
  String? selectedClass;
  bool isLoading = false;

  final kelasOptions = [
    '7A', '7B', '7C', '7D', '7E', '7F', '7G', '7H',
    '8A', '8B', '8C', '8D', '8E', '8F', '8G', '8H',
    '9A', '9B', '9C', '9D', '9E', '9F', '9G', '9H',
  ];

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    nipController.dispose();
    nisnController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan password harus diisi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedRole == null) {
      Get.snackbar(
        'Error',
        'Silakan pilih role terlebih dahulu!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedRole == 'Staf/Guru' && nipController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'NIP harus diisi untuk Staf/Guru!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedRole == 'Siswa') {
      if (nisnController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'NISN harus diisi untuk Siswa!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      if (selectedClass == null) {
        Get.snackbar(
          'Error',
          'Kelas harus dipilih untuk Siswa!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    setState(() => isLoading = true);

    final success = await authService.login(
      username: usernameController.text,
      password: passwordController.text,
      role: selectedRole!,
      nip: selectedRole == 'Staf/Guru' ? nipController.text : null,
      nisn: selectedRole == 'Siswa' ? nisnController.text : null,
      className: selectedRole == 'Siswa' ? selectedClass : null,
    );

    setState(() => isLoading = false);

    if (success) {
      Get.snackbar(
        'Berhasil',
        'Login berhasil sebagai $selectedRole!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Error',
        'Login gagal. Periksa kembali data Anda.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 3),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back, color: Color(0xFF1E3C72)),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school,
                          size: 80, color: Color(0xFF1E3C72)),
                      const SizedBox(height: 16),
                      const Text(
                        "Login Akun SMPN 1 Kota Jambi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: "Masuk sebagai",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "Siswa", child: Text("Siswa")),
                          DropdownMenuItem(
                              value: "Staf/Guru", child: Text("Staf / Guru")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                      if (selectedRole == "Staf/Guru") ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: nipController,
                          decoration: InputDecoration(
                            labelText: 'Masukkan NIP',
                            prefixIcon: const Icon(Icons.credit_card_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                      if (selectedRole == "Siswa") ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: nisnController,
                          decoration: InputDecoration(
                            labelText: 'Masukkan NISN',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedClass,
                          decoration: InputDecoration(
                            labelText: "Pilih Kelas",
                            prefixIcon: const Icon(Icons.class_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          items: kelasOptions
                              .map((kelas) => DropdownMenuItem(
                            value: kelas,
                            child: Text(kelas),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClass = value;
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3C72),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: isLoading ? null : handleLogin,
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Registrasi",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32, color: Colors.grey),
                      const Text(
                        "Atau masuk dengan",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.g_mobiledata, Colors.red),
                          const SizedBox(width: 20),
                          _socialButton(Icons.facebook, Colors.blue),
                          const SizedBox(width: 20),
                          _socialButton(Icons.apple, Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}