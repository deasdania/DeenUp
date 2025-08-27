import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deenup/controller/auth_controller.dart';
import 'package:deenup/controller/jadwal_sholat_controller.dart';
import 'package:deenup/const/main_themes.dart';


class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final JadwalSholatController jadwalController = Get.find<JadwalSholatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.arimo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(Constant.mainColor),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(Constant.mainColor),
              Color(0xFFE8F4FD),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {  // Wrap the entire body in Obx
            final User? user = authController.currentUser.value;  // Access the user within Obx

            if (user == null) {
              return Center(
                child: Text(
                  'Not logged in',
                  style: GoogleFonts.arimo(fontSize: 16),
                ),
              ); // Handle the case where the user is not logged in
            }
            final email = user.email ?? 'No email';  // Access email from the user object
            final cityName = jadwalController.selectedCityName;
            final cityID = jadwalController.selectedCityId;

            return Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(Constant.mainColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Color(Constant.mainColor),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.displayName ?? 'User',  // Access displayName from the user object
                        style: GoogleFonts.arimo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        email,
                        style: GoogleFonts.arimo(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.emailVerified == true
                              ? Color(0xFF27AE60).withOpacity(0.1)
                              : Color(0xFFE74C3C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.emailVerified == true ? Icons.verified : Icons.warning,
                              size: 16,
                              color: user.emailVerified == true
                                  ? Color(0xFF27AE60)
                                  : Color(0xFFE74C3C),
                            ),
                            SizedBox(width: 4),
                            Text(
                              user.emailVerified == true ? 'Verified' : 'Not Verified',
                              style: GoogleFonts.arimo(
                                fontSize: 12,
                                color: user.emailVerified == true
                                    ? Color(0xFF27AE60)
                                    : Color(0xFFE74C3C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Information Cards
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoCard(
                          'Account Information',
                          [
                            _buildInfoRow('Email', email),
                            _buildInfoRow('User ID', user.uid),
                            _buildInfoRow(
                              'Created',
                              user.metadata.creationTime?.toString().split(' ')[0] ?? 'Unknown',
                            ),
                            _buildInfoRow(
                              'Last Sign In',
                              user.metadata.lastSignInTime?.toString().split(' ')[0] ?? 'Unknown',
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // App Preferences
                        _buildInfoCard(
                          'App Preferences',
                          [
                            _buildInfoRow('Selected City', cityName.value),
                            _buildInfoRow('City ID', cityID.value),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Action Buttons
                        _buildActionCard(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.arimo(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.arimo(
                fontSize: 14,
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: GoogleFonts.arimo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 16),

          // Send Email Verification Button (if not verified)
          Obx(() {
            final user = authController.currentUser.value;
            if (user != null && !user.emailVerified) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text(
                      'Send Verification Email',
                      style: GoogleFonts.arimo(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(Constant.mainColor),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _sendVerificationEmail(),
                  ),
                ),
              );
            }
            return SizedBox();
          }),

          // Refresh Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Refresh Profile',
                style: GoogleFonts.arimo(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27AE60),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _refreshProfile(),
            ),
          ),
          SizedBox(height: 12),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Logout',
                style: GoogleFonts.arimo(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE74C3C),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _showLogoutDialog(),
            ),
          ),
        ],
      ),
    );
  }

  void _sendVerificationEmail() async {
    try {
      await authController.currentUser.value?.sendEmailVerification();
      Get.snackbar(
        'Success',
        'Verification email sent! Please check your inbox.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF27AE60),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    }
  }

  void _refreshProfile() async {
    try {
      await authController.currentUser.value?.reload();
      await FirebaseAuth.instance.currentUser?.reload();
      authController.currentUser.refresh();

      Get.snackbar(
        'Success',
        'Profile refreshed successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF27AE60),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh profile: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    }
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Logout',
          style: GoogleFonts.arimo(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.arimo(color: Color(0xFF7F8C8D)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.arimo(color: Color(0xFF7F8C8D)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE74C3C),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.arimo(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
