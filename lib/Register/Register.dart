import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SizedBox.expand(
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
                    _buildPhoneInput(),
                    const SizedBox(height: 20),
                    _buildUsernameInput(),
                    const SizedBox(height: 20),
                    _buildPasswordInput(),
                    const SizedBox(height: 40),
                    _buildJunpToLoginPage(context),
                    const SizedBox(height: 40),
                    _buildConfirmButton(context),
                    const SizedBox(height: 30),
                  ],
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
    return Center(
      child: Text(
        'Register',
        style: GoogleFonts.ubuntu(
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

  // Confirm Button
  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          //点击后的事件
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
          child: Center(
            child: Text(
              'Confirm',
              style: GoogleFonts.ubuntu(
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

  Widget _buildJunpToLoginPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Have an account?',
              style: GoogleFonts.ubuntu(
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
       border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
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
      style: GoogleFonts.ubuntu(fontSize: 16),
    );
  }
}
