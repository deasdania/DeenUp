import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deenup/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    
    // If user is not logged in and trying to access protected route
    if (user == null && _isProtectedRoute(route)) {
      // Show snackbar message
      Get.snackbar(
        'Access Denied',
        'Silakan login terlebih dahulu untuk mengakses fitur ini',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return RouteSettings(name: AppRoutes.login);
    }
    
    return null;
  }

  bool _isProtectedRoute(String? route) {
    // Define which routes require authentication
    final protectedRoutes = [
      AppRoutes.jadwalSholat, // Now JadwalSholat page requires authentication
    ];
    
    return protectedRoutes.contains(route);
  }
}