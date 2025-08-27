import 'package:get/get.dart';
import 'package:deenup/pages/jadwal_sholat_page.dart';
import 'package:deenup/pages/getstarted_page.dart';
import 'package:deenup/pages/login_page.dart';
import 'package:deenup/pages/register_page.dart';
import 'package:deenup/pages/splash_screen.dart';
import 'package:deenup/pages/profile_page.dart';
import 'package:deenup/pages/guess_jadwal_sholat_page.dart';
import 'package:deenup/binding/jadwal_sholat_binding.dart';
import 'package:deenup/binding/auth_binding.dart';
import 'package:deenup/middleware/auth_middleware.dart';

class AppRoutes {
  static const String splash = '/';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String register = '/register';
  static const String jadwalSholat = '/jadwal-sholat';
  static const String profile = '/profile';
  static const String guestJadwalSholat = '/guest-jadwal-sholat';
  
  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: getStarted,
      page: () => GetstartedPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: jadwalSholat,
      page: () => JadwalSholatPage(),
      bindings: [
        AuthBinding(),
        JadwalSholatBinding(),
      ],
      // Add middleware to protect this route
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
      bindings: [
        AuthBinding(),
        JadwalSholatBinding(),
      ],
      // Add middleware to protect this route
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: guestJadwalSholat,
      page: () => GuestJadwalSholatPage(),
      binding: JadwalSholatBinding(),
    ),
  ];
}