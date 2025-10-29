import 'package:get/get.dart';
import '../modules/beranda/beranda_page.dart';
import '../modules/auth/login_page.dart';
import '../modules/home/home_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BERANDA;

  static final routes = [
    GetPage(
      name: _Paths.BERANDA,
      page: () => const BerandaPage(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
    ),
  ];
}