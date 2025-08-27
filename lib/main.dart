import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deenup/routes/app_routes.dart';
import 'package:deenup/const/main_themes.dart';
import 'package:deenup/binding/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Register with GetX
  Get.put<SharedPreferences>(prefs);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DeenUp - Jadwal Sholat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(Constant.mainColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use routes with bindings
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.splash, // Start with splash screen
      
      // Global binding for authentication state management
      initialBinding: AuthBinding(),
      
      // Remove debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}