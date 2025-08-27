import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deenup/const/main_themes.dart';

class PrayerTimeCard extends StatelessWidget {
  final String name;
  final String? time;
  final String iconPath;

  const PrayerTimeCard({
    required this.name,
    this.time,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(Constant.mainColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              iconPath, // Load the image from the specified path
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.arimo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          Text(
            time ?? '--:--',
            style: GoogleFonts.arimo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3498DB),
            ),
          ),
        ],
      ),
    );
  }
}
