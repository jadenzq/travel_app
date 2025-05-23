import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
        children: [
          // 可滚动的主要内容区域
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildPhoneInput(),
                const SizedBox(height: 20),
                _buildUsernameInput(),
                const SizedBox(height: 20),
                _buildPasswordInput(),
                const SizedBox(height: 40),
                _buildConfirmButton(),
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
                  color: const Color(0xFFA8F1FF),  // 浅蓝色 #A8F1FF
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return const Center(
      child: Text(
      'Register',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    );
  }

  // Phone Input Field
  Widget _buildPhoneInput() {
    return _buildInputField(
      label: 'Phone Number',
      icon: Icons.phone_iphone_outlined,
      keyboardType: TextInputType.phone,
    );
  }

  // Username Input Field
  Widget _buildUsernameInput() {
    return _buildInputField(
      label: 'Username',
      icon: Icons.person_outline,
    );
  }

  // Password Input Field
  Widget _buildPasswordInput() {
    return _buildInputField(
      label: 'Password',
      icon: Icons.lock_outline,
      isPassword: true,
    );
  }

  // Confirm Button
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: () {
          //点击后的事件
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 25, 118, 210),
                Color.fromARGB(255, 13, 71, 161),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              'Confirm',
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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