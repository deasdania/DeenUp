import 'package:get/get.dart';
import 'package:deenup/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inject AuthController as a singleton
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}