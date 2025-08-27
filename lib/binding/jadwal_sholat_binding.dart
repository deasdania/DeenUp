import 'package:get/get.dart';
import 'package:deenup/controller/jadwal_sholat_controller.dart';
import 'package:deenup/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalSholatBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService as a singleton (will be created once and reused)
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);

    // Initialize SharedPreferences asynchronously
    Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
    );

    // Inject JadwalSholatController with ApiService and SharedPreferences dependencies
    Get.lazyPut<JadwalSholatController>(
      () => JadwalSholatController(
        Get.find<ApiService>(),
        Get.find<SharedPreferences>(),
      ),
      fenix: true,
    );
  }
}
