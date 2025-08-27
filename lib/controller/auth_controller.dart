import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deenup/routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;
  final Rxn<User> currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Login berhasil
      Get.snackbar(
        'Success',
        'Login berhasil!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
      // Navigate to jadwal sholat page
      Get.offAllNamed(AppRoutes.jadwalSholat);
      
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Registrasi berhasil
      Get.snackbar(
        'Success',
        'Registrasi berhasil!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
      // Send email verification
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        Get.snackbar(
          'Info',
          'Email verifikasi telah dikirim!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
          colorText: Get.theme.colorScheme.onPrimary,
        );
      }
      
      // Navigate to login page
      Get.offAllNamed(AppRoutes.login);
      
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'operation-not-allowed':
        return 'Email/password tidak diaktifkan';
      default:
        return 'Terjadi kesalahan tidak terduga';
    }
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.getStarted);
  }

  bool get isLoggedIn => currentUser.value != null;
}