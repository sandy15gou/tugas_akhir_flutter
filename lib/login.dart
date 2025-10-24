import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Login'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Ini halaman login',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}