import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('current_user');

    if (userData != null) {
      currentUser.value = User.fromJson(jsonDecode(userData));
      isLoggedIn.value = true;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    required String role,
    String? nip,
    String? nisn,
    String? className,
  }) async {
    // Validasi sederhana (dalam production, gunakan API backend)
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    // Validasi role-specific
    if (role == 'Staf/Guru' && (nip == null || nip.isEmpty)) {
      return false;
    }

    final user = User(
      username: username,
      role: role,
      nip: nip,
      nisn: nisn,
      className: className,
    );

    // Simpan user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));

    currentUser.value = user;
    isLoggedIn.value = true;

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');

    currentUser.value = null;
    isLoggedIn.value = false;
  }

  bool canManageAllClasses() {
    return currentUser.value?.isStaff() ?? false;
  }

  String? getStudentClass() {
    return currentUser.value?.className;
  }
}