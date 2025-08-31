import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deenup/controller/jadwal_sholat_controller.dart';
import 'package:deenup/routes/app_routes.dart';
import 'package:deenup/const/main_themes.dart';
import 'package:deenup/widgets/prayer_card.dart';

class GuestJadwalSholatPage extends StatelessWidget {
  final JadwalSholatController _controller = Get.find<JadwalSholatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Times',
          style: GoogleFonts.arimo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(Constant.mainColor),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.login, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            onPressed: () => Get.toNamed(AppRoutes.login),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(Constant.mainColor), Color(0xFFE8F4FD)],
            stops: [0.0, 0.3],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildGuestNotice(),
              _buildCitySelector(_controller),
              _buildDatePicker(context),
              _buildPrayerTimes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestNotice() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Color.fromARGB(255, 239, 0, 0)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest Mode',
                  style: GoogleFonts.arimo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 239, 0, 0),
                  ),
                ),
                Text(
                  'Login for full features and data sync',
                  style: GoogleFonts.arimo(
                    fontSize: 12,
                    color: Color.fromARGB(255, 239, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector(JadwalSholatController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
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
            'Select City',
            style: GoogleFonts.arimo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller.citySearchController,
            onChanged: (value) => controller.searchCities(value),
            decoration: InputDecoration(
              hintText: 'Search cities',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  controller.resetSearch();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 10),
          Obx(
            () =>
                controller
                    .isExpanded
                    .value // Use controller.isExpanded
                ? Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: controller.filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = controller.filteredCities[index];
                        return ListTile(
                          title: Text(city.lokasi ?? ''),
                          onTap: () {
                            controller.updateSelectedCity(city);
                          },
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
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
            'Select Date',
            style: GoogleFonts.arimo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 10),
          Obx(
            () => GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _controller.selectedDate.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Color(Constant.mainColor),
                        ),
                        dialogBackgroundColor:
                            Colors.white, // Set background color of the dialog
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  _controller.updateSelectedDate(picked);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(
                        'dd MMMM yyyy',
                      ).format(_controller.selectedDate.value),
                      style: GoogleFonts.arimo(
                        fontSize: 14,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Color(Constant.mainColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimes() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
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
              'Prayer Times',
              style: GoogleFonts.arimo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_controller.prayerTimes.value == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFFE74C3C),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load prayer times',
                          style: GoogleFonts.arimo(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Display
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prayer times cards
                      PrayerTimeCard(
                        name: 'Fajr',
                        time: _controller.prayerTimes.value!.subuh,
                        iconPath: 'assets/icons/Shalat-Shubuh.png',
                      ),
                      PrayerTimeCard(
                        name: 'Dhuhr',
                        time: _controller.prayerTimes.value!.dzuhur,
                        iconPath: 'assets/icons/Shalat-Zhuhur.png',
                      ),
                      PrayerTimeCard(
                        name: 'Asr',
                        time: _controller.prayerTimes.value!.ashar,
                        iconPath: 'assets/icons/Shalat-Ashar.png',
                      ),
                      PrayerTimeCard(
                        name: 'Maghrib',
                        time: _controller.prayerTimes.value!.maghrib,
                        iconPath: 'assets/icons/Shalat-Maghrib.png',
                      ),
                      PrayerTimeCard(
                        name: 'Isha',
                        time: _controller.prayerTimes.value!.isya,
                        iconPath: 'assets/icons/Shalat-Isya.png',
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
