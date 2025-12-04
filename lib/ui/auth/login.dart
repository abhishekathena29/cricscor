import 'package:cricscor/ui/auth/provider/auth_provider.dart';
import 'package:cricscor/ui/auth/signup.dart';
import 'package:cricscor/ui/main_shell.dart';
import 'package:cricscor/ui/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MinimalLoginPage extends StatelessWidget {
  MinimalLoginPage({super.key});

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive padding
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Use a background color slightly off-white for contrast
      backgroundColor: const Color(0xFFF7F9FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- 1. Header/Logo Section ---
              const Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Color(0xFF0D47A1), // A deep blue accent
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              // --- 2. Email Field ---
              _buildTextField(
                hintText: 'Email Address',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // --- 3. Password Field ---
              _buildTextField(
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              // --- 4. Login Button ---
              Consumer<AuthenProvider>(
                builder: (context, provider, _) {
                  return ElevatedButton(
                    onPressed: () async {
                      final res = await provider.signIn(
                        email: _emailController.text,
                        password: _passController.text,
                      );
                      if (context.mounted) {
                        if (res) {
                          pushAndRemoveuntilScreen(context, MainShell());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Something went Wrong')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF0D47A1), // Deep blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'LOG IN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // --- 5. Footer Link ---
              TextButton(
                onPressed: () {
                  // Add forgot password navigation logic here
                  pushScreen(context, MinimalSignupPage());
                },
                child: const Text(
                  'I don\'t an account, Create a new',
                  style: TextStyle(color: Color(0xFF0D47A1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for consistent text field styling
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isPassword
            ? TextInputType.text
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
