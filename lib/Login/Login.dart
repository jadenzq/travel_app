import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/Register/register.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback onLogIn;

  const LoginPage({super.key, required this.onLogIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _loading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      widget.onLogIn(); // Trigger refresh from RootPage

    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _emailError = 'Email not found.';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password.';
        } else {
          _generalError = 'Login failed. Please try again.';
        }
      });
    } catch (_) {
      setState(() {
        _generalError = 'An unexpected error occurred.';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _navigateToRegister() async {
    final registrationSuccessful = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const RegisterPage()),
    );

    // If registrationSuccessful is true, trigger the onLogIn callback
    if (registrationSuccessful == true) {
      widget.onLogIn(); // This will trigger _initializeUser and navigate to HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
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
                _buildPasswordInput(),
                if (_generalError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _generalError!,
                    style: GoogleFonts.ubuntu(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 10),
                _buildFooterLinks(context),
                const SizedBox(height: 20),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Login',
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
      decoration: _inputDecoration('Email', Icons.email_outlined)
          .copyWith(errorText: _emailError),
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

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: _inputDecoration('Password', Icons.lock)
          .copyWith(errorText: _passwordError),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required.';
        }
        return null;
      },
    );
  }


    Widget _buildFooterLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
              onPressed: _navigateToRegister, // Call the new method
              child: const Text('Don\'t have an account? Register here.'),
            ),

      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: _loading ? null : _login,
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
                    'Login',
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
