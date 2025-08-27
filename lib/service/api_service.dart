import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:deenup/model/jadwal_sholat_model.dart';
import 'package:deenup/model/city_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<JadwalSholatModel?> getPrayerTimes(String cityId, DateTime date) async {
    try {
      // Format the date as 'YYYY-MM-DD'
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final url = 'https://api.myquran.com/v2/sholat/jadwal/$cityId/$formattedDate';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        // Access the 'data' field from the main response
        final Map<String, dynamic> jsonResponse = response.data;
        final Map<String, dynamic> data = jsonResponse['data'];

        // Extract the jadwal (prayer times) data
        final Map<String, dynamic> jadwal = data['jadwal'];

        // Create JadwalSholatModel
        return JadwalSholatModel(
          date: data['tanggal'],
          imsak: jadwal['imsak'],
          subuh: jadwal['subuh'],
          terbit: jadwal['terbit'],
          dhuha: jadwal['dhuha'],
          dzuhur: jadwal['dzuhur'],
          ashar: jadwal['ashar'],
          maghrib: jadwal['maghrib'],
          isya: jadwal['isya'],
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load prayer times. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching prayer times: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<List<CityModel>> getAllCities() async {
    try {
      final response = await _dio.get('https://api.myquran.com/v2/sholat/kota/semua');

      if (response.statusCode == 200) {
        // Access the 'data' field from the main response
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> data = jsonResponse['data'];

        List<CityModel> cities = data.map((item) => CityModel.fromJson(item)).toList();
        return cities;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load cities. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching cities: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    }
  }
}
