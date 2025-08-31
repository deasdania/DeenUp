import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deenup/controller/auth_controller.dart';
import 'package:deenup/routes/app_routes.dart';
import 'package:deenup/const/main_themes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  void handleBackNavigation(context) {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.toNamed(AppRoutes.getStarted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => handleBackNavigation(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.mosque,
                        size: 120,
                        color: Color(Constant.mainColor),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Login to DeenUp',
                        style: GoogleFonts.arimo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  label: "Input Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  label: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus diisi';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                Obx(() => SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff3498DB),
                    ),
                    onPressed: authController.isLoading.value ? null : () {
                      if (_formKey.currentState!.validate()) {
                        authController.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: authController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )),
                const SizedBox(height: 49),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do not have an account yet? ',
                      style: GoogleFonts.arimo(color: Color(0xFF7F8C8D)),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text(
                        'Register here',
                        style: GoogleFonts.arimo(
                          color: Color(0xff3498DB),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key, 
    required this.label,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
  });
  
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: GoogleFonts.arimo(color: const Color(0xffC0C0C0)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC0C0C0)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff3498DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xffC0C0C0),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}