import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:deenup/routes/app_routes.dart';
import 'package:deenup/const/main_themes.dart';

class GetstartedPage extends StatelessWidget {
  const GetstartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Add this
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 86),
                  width: double.infinity,
                  height: 330,
                  child: Icon(
                    Icons.mosque,
                    size: 200,
                    color: Color(Constant.mainColor),
                  ),
                ),
                SizedBox(height: 37),
                Text(
                  'Welcome to\nDeenUp',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                SizedBox(height: 21),
                Text(
                  'Trusted Prayer Schedule App\nFor Your Islamic Life',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    fontSize: 16,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                SizedBox(height: 30), // Adjust for additional spacing
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.login);
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.arimo(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Color(Constant.mainColor)),
                            backgroundColor: Color(Constant.mainColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.register);
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.arimo(
                              fontSize: 15,
                              color: Color(Constant.mainColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Color(Constant.mainColor)),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      // Guest access option
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.guestJadwalSholat);
                          },
                          child: Text(
                            'Continue as Guest',
                            style: GoogleFonts.arimo(
                              fontSize: 15,
                              color: Color(0xFF7F8C8D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF7F8C8D)),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Guest mode has limited features.\nRegister for the full experience.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arimo(
                            fontSize: 12,
                            color: Color(0xFF95A5A6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
