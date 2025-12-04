import 'package:cricscor/ui/auth/provider/auth_provider.dart';
import 'package:cricscor/ui/main_shell.dart';
import 'package:cricscor/ui/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MinimalSignupPage extends StatefulWidget {
  const MinimalSignupPage({super.key});

  @override
  State<MinimalSignupPage> createState() => _MinimalSignupPageState();
}

class _MinimalSignupPageState extends State<MinimalSignupPage> {
  // 0 = Player, 1 = Scorer
  final List<bool> _isSelected = [true, false];
  String _userType = 'Player'; // Initial selected user type

  void _onUserTypeSelected(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
      _userType = index == 0 ? 'Player' : 'Scorer';
      print('Selected User Type: $_userType');
    });
  }

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const Color accentColor = Color(0xFF0D47A1);

    return Scaffold(
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
                Icons.person_add_alt_1_rounded,
                size: 80,
                color: accentColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // --- 2. User Type Selector (New Addition) ---
              const Text(
                'Select Account Type:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                isSelected: _isSelected,
                onPressed: _onUserTypeSelected,
                borderRadius: BorderRadius.circular(10),
                borderColor: accentColor.withOpacity(0.5),
                selectedBorderColor: accentColor,
                fillColor: accentColor,
                borderWidth: 1.5,
                // constraints: BoxConstraints(
                //   minWidth:
                //       (MediaQuery.of(context).size.width - 64) /
                //       2, // Distribute width evenly
                //   minHeight: 45.0,
                // ),
                children: <Widget>[
                  _buildToggleItem(
                    text: 'Player',
                    icon: Icons.sports_soccer,
                    isSelected: _isSelected[0],
                  ),
                  _buildToggleItem(
                    text: 'Scorer',
                    icon: Icons.rate_review,
                    isSelected: _isSelected[1],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- 3. Input Fields ---
              _buildTextField(
                controller: _usernameController,
                hintText: 'Username',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email Address',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _confirmPassController,
                hintText: 'Confirm Password',
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              // --- 4. Signup Button ---
              Consumer<AuthenProvider>(
                builder: (context, provider, _) {
                  return provider.loading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            final res = await provider.signUp(
                              email: _emailController.text,
                              password: _passController.text,
                              userType: _userType,
                              username: _userType,
                            );
                            if (context.mounted) {
                              if (res) {
                                pushAndRemoveuntilScreen(context, MainShell());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Something went Wrong'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'SIGN UP',
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

              // --- 5. Footer Link (To Login) ---
              TextButton(
                onPressed: () {
                  // Add navigation logic back to login pag
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for ToggleButtons item content
  Widget _buildToggleItem({
    required String text,
    required IconData icon,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : const Color(0xFF333333),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Helper widget for consistent text field styling
  Widget _buildTextField({
    required TextEditingController controller,
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
        controller: controller,
        obscureText: isPassword,
        keyboardType: isPassword
            ? TextInputType.text
            : (hintText.contains('Email')
                  ? TextInputType.emailAddress
                  : TextInputType.text),
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
