import 'package:flutter/material.dart';
import 'package:travel_app/Profile/profile.dart';
import 'package:travel_app/Register/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SizedBox.expand(
          child: Stack(
            children: [
              // 可滚动的主要内容区域
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildAccountInput(),
                    const SizedBox(height: 20),
                    _buildPasswordInput(),
                    const SizedBox(height: 10),
                    _buildFooterLinks(context),
                    const SizedBox(height: 40),
                    _buildLoginButton(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // 固定在底部的Welcome
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Welcome to myapp',
                    style: TextStyle(
                      fontSize: 32,
                      color: const Color(0xFFA8F1FF),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return const Center(
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  // Account Input Field
  Widget _buildAccountInput() {
    return _buildInputField(label: 'Username', icon: Icons.person_outline);
  }

  // Password Input Field
  Widget _buildPasswordInput() {
    return _buildInputField(
      label: 'Password',
      icon: Icons.lock_outline,
      isPassword: true,
    );
  }

  // Forgot Password Link
  Widget _buildFooterLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Do not have an account?',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Login Button (unchanged)
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: () {
          onLogIn();
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(54, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 输入框组件 with square borders and no shadow
  Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        // Square border with visible outline
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Square corners
          borderSide: BorderSide(color: Colors.grey), // Visible border
        ),
        // Focused border (blue)
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}