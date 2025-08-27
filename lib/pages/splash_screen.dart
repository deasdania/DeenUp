import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deenup/routes/app_routes.dart';
import 'package:deenup/const/main_themes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAppState();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    
    // Start text animation after a delay
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  void _checkAppState() async {
    // Add a minimum splash duration for better UX
    await Future.delayed(Duration(seconds: 2));
    
    try {
      final prefs = Get.find<SharedPreferences>();
      final user = FirebaseAuth.instance.currentUser;
      
      // Check if this is the first time opening the app
      final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
      
      if (isFirstTime) {
        // First time user - show get started page
        await prefs.setBool('is_first_time', false);
        Get.offAllNamed(AppRoutes.getStarted);
      } else {
        // Returning user - check authentication status
        if (user != null) {
          // User is logged in - check if email is verified
          await user.reload(); // Refresh user data
          final updatedUser = FirebaseAuth.instance.currentUser;
          
          if (updatedUser != null && updatedUser.emailVerified) {
            // Verified user - go directly to main app
            Get.offAllNamed(AppRoutes.jadwalSholat);
          } else {
            // Unverified user - show login with verification reminder
            Get.offAllNamed(AppRoutes.login);
            if (updatedUser != null && !updatedUser.emailVerified) {
              Get.snackbar(
                'Email Verification Required',
                'Please verify your email to access all features',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Color(0xFFF39C12),
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
            }
          }
        } else {
          // User not logged in - show get started page with options
          Get.offAllNamed(AppRoutes.getStarted);
        }
      }
    } catch (e) {
      // Error handling - fallback to get started page
      print('Error in splash screen: $e');
      Get.offAllNamed(AppRoutes.getStarted);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(Constant.mainColor),
              Color(0xFF2980B9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated app icon
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mosque,
                        size: 60,
                        color: Color(Constant.mainColor),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              
              // Animated app name and tagline
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _textAnimation.value)),
                      child: Column(
                        children: [
                          // App name
                          Text(
                            'DeenUp',
                            style: GoogleFonts.arimo(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          
                          // Tagline
                          Text(
                            'Jadwal Sholat Terpercaya',
                            style: GoogleFonts.arimo(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 60),
              
              // Loading indicator with pulse animation
              Container(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsing circle
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Container(
                          width: 50 * (0.8 + 0.4 * _logoController.value),
                          height: 50 * (0.8 + 0.4 * _logoController.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        );
                      },
                    ),
                    // Loading spinner
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              // Loading text
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value * 0.7,
                    child: Text(
                      'Memuat aplikasi...',
                      style: GoogleFonts.arimo(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}