import 'package:flutter/material.dart'; // Import for TextEditingController
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deenup/service/api_service.dart';
import 'package:deenup/model/jadwal_sholat_model.dart';
import 'package:deenup/model/city_model.dart';

class JadwalSholatController extends GetxController {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  // Add TextEditingController
  final TextEditingController citySearchController = TextEditingController();

  final Rxn<JadwalSholatModel> _prayerTimes = Rxn<JadwalSholatModel>();
  final RxBool _isLoading = false.obs;
  final RxList<CityModel> _cities = <CityModel>[].obs;
  final RxList<CityModel> _filteredCities = <CityModel>[].obs;
  final RxString _selectedCityId = '1225'.obs;
  final RxString _selectedCityName = 'Jakarta'.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final _isSearching = false.obs;

  JadwalSholatController(this._apiService, this._prefs);

  Rxn<JadwalSholatModel> get prayerTimes => _prayerTimes;
  RxBool get isLoading => _isLoading;
  RxList<CityModel> get cities => _cities;
  RxList<CityModel> get filteredCities => _filteredCities;
  RxString get selectedCityId => _selectedCityId;
  RxString get selectedCityName => _selectedCityName;
  Rx<DateTime> get selectedDate => _selectedDate;
  bool get isSearching => _isSearching.value;

  final RxBool isExpanded = true.obs;

  @override
  void onInit() {
    super.onInit();
    print("JadwalSholatController initialized"); // Add this line

    citySearchController.addListener(() {
      if (citySearchController.text.isEmpty) {
        isExpanded.value = true;
      } else {
        isExpanded.value = false;
      }
    });

    loadCachedLocation();
    loadCities();
  }

  @override
  void onClose() {
    print("JadwalSholatController disposed"); // Add this line
    citySearchController.dispose();
    super.onClose();
  }

  Future<void> loadCachedLocation() async {
    try {
      final cachedCityId = _prefs.getString('selected_city_id');
      final cachedCityName = _prefs.getString('selected_city_name');

      if (cachedCityId != null && cachedCityName != null) {
        _selectedCityId.value = cachedCityId;
        _selectedCityName.value = cachedCityName;
        citySearchController.text = cachedCityName; // Set initial text
        fetchPrayerTimes(_selectedCityId.value, _selectedDate.value);
      } else {
        fetchPrayerTimes(_selectedCityId.value, _selectedDate.value);
      }
    } catch (e) {
      print('Error loading cached location: $e');
      fetchPrayerTimes(_selectedCityId.value, _selectedDate.value);
    }
  }

  Future<void> saveSelectedLocation(String cityId, String cityName) async {
    try {
      await _prefs.setString('selected_city_id', cityId);
      await _prefs.setString('selected_city_name', cityName);
      _selectedCityId.value = cityId;
      _selectedCityName.value = cityName;
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  Future<void> fetchPrayerTimes(String cityId, DateTime date) async {
    _isLoading.value = true;
    _prayerTimes.value = await _apiService.getPrayerTimes(cityId, date);
    _isLoading.value = false;
  }

  Future<void> loadCities() async {
    final cityList = await _apiService.getAllCities();
    if (cityList.isNotEmpty) {
      _cities.value = cityList;
      _filteredCities.value = cityList;

      if (_selectedCityName.value.isEmpty) {
        final selectedCity = _cities.firstWhereOrNull(
          (city) => city.id == _selectedCityId.value,
        );
        if (selectedCity != null) {
          _selectedCityName.value = selectedCity.lokasi ?? 'Unknown';
          citySearchController.text =
              selectedCity.lokasi ?? ''; // Set initial text
        }
      }
    }
  }

  void changeCity(String cityId) {
    final selectedCity = _cities.firstWhereOrNull((city) => city.id == cityId);
    if (selectedCity != null) {
      saveSelectedLocation(cityId, selectedCity.lokasi ?? 'Unknown');
      citySearchController.text = selectedCity.lokasi ?? ''; // Update text
      fetchPrayerTimes(cityId, _selectedDate.value);
    }
  }

  void changeDate(DateTime date) {
    _selectedDate.value = date;
    fetchPrayerTimes(_selectedCityId.value, date);
  }

  void searchCities(String query) {
    isExpanded.value = true;
    citySearchController.text = query;
    if (query.isEmpty) {
      _filteredCities.value = _cities;
      isExpanded.value = true;
    } else {
      _filteredCities.value = _cities
          .where(
            (city) =>
                city.lokasi?.toLowerCase().contains(query.toLowerCase()) ??
                false,
          )
          .toList();
      isExpanded.value = true;
    }
  }

  void resetSearch() {
    isExpanded.value = true;
    _filteredCities.value = _cities;
    citySearchController.clear();
  }

  CityModel? get selectedCity {
    return _cities.firstWhereOrNull((city) => city.id == _selectedCityId.value);
  }

  void updateSelectedCity(CityModel city) {
    _selectedCityId.value = city.id ?? '';
    _selectedCityName.value = city.lokasi ?? 'Unknown';
    saveSelectedLocation(_selectedCityId.value, _selectedCityName.value);
    citySearchController.text = city.lokasi ?? '';
    isExpanded.value = false;
    fetchPrayerTimes(_selectedCityId.value, _selectedDate.value);
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.value = date;
    fetchPrayerTimes(_selectedCityId.value, date);
  }
}
