import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  double _notificationOpacity = 0.0;
  String _notificationMessage = '';
  Timer? _notificationTimer;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _loading = true);

      // 1. Check phone duplicate
      final phoneExists = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (phoneExists.docs.isNotEmpty) {
        _showError("Phone number already used.");
        return;
      }

      // 2. Register with email + password
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 3. Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'phone': phone,
      });

      if (!mounted) return;
      _showCustomNotification("Registration successful!");
      Navigator.of(context).pop(true); // 返回登录页面
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed.';
      if (e.code == 'email-already-in-use') {
        message = 'Email already registered.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      }
      _showError(message);
    } catch (e) {
      _showError("Unexpected error occurred.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    _showCustomNotification(message);
    setState(() => _loading = false);
  }

  void _showCustomNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationOpacity = 1.0;
    });

    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _notificationOpacity = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildEmailInput(),
                      const SizedBox(height: 20),
                      _buildPhoneInput(),
                      const SizedBox(height: 20),
                      _buildUsernameInput(),
                      const SizedBox(height: 20),
                      _buildPasswordInput(),
                      const SizedBox(height: 40),
                      _buildJunpToLoginPage(context),
                      const SizedBox(height: 40),
                      _buildConfirmButton(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            _popUpNotification(),
          ],
        ),
      ),
    );
  }

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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email', Icons.email_outlined),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required.';
        }
        if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$').hasMatch(value)) {
          return 'Enter a valid email address.';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration('Phone Number', Icons.phone),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone number is required.';
        }
        if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
          return 'Enter a valid phone number.';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameInput() {
    return TextFormField(
      controller: _usernameController,
      decoration: _inputDecoration('Username', Icons.person),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username is required.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: _inputDecoration('Password', Icons.lock),
      validator: (value) {
        if (value == null || value.length < 8 || value.length > 16) {
          return 'Password must be 8–16 characters.';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Include upper/lowercase letters and numbers.';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: _loading ? null : _register,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _loading ? Colors.grey : Colors.blue,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(54, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
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
          onTap: () => Navigator.of(context).pop(),
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

  Widget _popUpNotification() {
    return AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              bottom: _notificationOpacity > 0 ? 20 : -100,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _notificationOpacity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _notificationMessage,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }
}
