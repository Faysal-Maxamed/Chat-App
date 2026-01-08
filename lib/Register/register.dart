import 'package:chat_app/Register/register_controller.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Consumer<RegisterController>(
        builder: (context, register, child) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      "Join the community today!",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: kTextLightColor,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildInputField(
                      label: "Phone Number",
                      hint: "e.g. +252...",
                      icon: Icons.phone_android_rounded,
                      onChanged: (value) => register.getPhoneNumber(value),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: "Email Address",
                      hint: "user@example.com",
                      icon: Icons.email_outlined,
                      onChanged: (value) => register.getEmail(value),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: "Password",
                      hint: "••••••••",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      onChanged: (value) => register.getPassword(value),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: register.isLoading
                            ? null
                            : () => register.register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 8,
                          shadowColor: kPrimaryColor.withOpacity(0.3),
                        ),
                        child: register.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(color: kTextLightColor),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      obscureText: isPassword,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: kTextLightColor, fontSize: 14),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: kTextLightColor.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: kPrimaryColor, size: 22),
        filled: true,
        fillColor: kSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: kPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
