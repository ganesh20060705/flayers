import 'package:flutter/material.dart';
import 'dart:math';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  // 🔹 Generate random team code
  String _generateTeamCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return 'TEAM-${List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join()}';
  }

  // 🔹 Loading dialog
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoadingIfOpen() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // 🔹 Error message display
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _validateInput(String email, String password, String? confirmPassword, String? name) {
    if (email.isEmpty || !email.contains('@')) {
      return 'The email address is not valid.';
    }
    if (password.isEmpty || password.length < 6) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (!showLogin) {
      if (name == null || name.isEmpty) {
        return 'Please enter your name.';
      }
      if (confirmPassword == null || password != confirmPassword) {
        return 'Passwords do not match.';
      }
    }
    return '';
  }

  // 🔹 Unified authentication handler (mock implementation)
  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final confirmPassword = confirmPassController.text.trim();
    final name = nameController.text.trim();

    // Validate input
    final validationError = _validateInput(
      email, 
      password, 
      showLogin ? null : confirmPassword, 
      showLogin ? null : name
    );
    
    if (validationError.isNotEmpty) {
      _showError(validationError);
      return;
    }

    _showLoading();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (showLogin) {
        // LOGIN FLOW - Mock authentication
        // In a real app, you would validate credentials against your database here
      } else {
        // SIGNUP FLOW - Mock signup
        // In a real app, you would save user data to your database here
        // Generate team code for new users
        String teamCode = _generateTeamCode();
        // Store user data locally or in your preferred database
        debugPrint('New user signup: $name, $email, TeamCode: $teamCode');
      }

      // NAVIGATE TO HOME AFTER SUCCESS
      _hideLoadingIfOpen();
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/home_page");
      }
    } catch (e) {
      _hideLoadingIfOpen();
      _showError('Something went wrong. ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _toggleButtons(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showLogin ? _loginForm() : _signupForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Header
  Widget _header() => Container(
        width: double.infinity,
        height: 180,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9DFF57), Color(0xFF00C853)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: const Center(
          child: Icon(Icons.eco, size: 80, color: Colors.black),
        ),
      );

  // ✅ Toggle Login / Signup
  Widget _toggleButtons() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _toggle("Login", true),
            _toggle("Sign Up", false),
          ],
        ),
      );

  Widget _toggle(String text, bool login) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => showLogin = login),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: showLogin == login
                  ? const Color(0xFF00C853)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: showLogin == login ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  // ✅ Login Form
  Widget _loginForm() => Padding(
        key: const ValueKey("Login"),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textField(emailController, "Email"),
            const SizedBox(height: 16),
            _textField(passController, "Password", obscure: true),
            const SizedBox(height: 20),
            _authButton("Log In", handleAuth),
          ],
        ),
      );

  // ✅ Signup Form
  Widget _signupForm() => Padding(
        key: const ValueKey("Signup"),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textField(nameController, "Name"),
              const SizedBox(height: 16),
              _textField(emailController, "Email"),
              const SizedBox(height: 16),
              _textField(passController, "Password", obscure: true),
              const SizedBox(height: 16),
              _textField(confirmPassController, "Confirm Password",
                  obscure: true),
              const SizedBox(height: 20),
              _authButton("Sign Up", handleAuth),
            ],
          ),
        ),
      );

  // ✅ Text Field
  Widget _textField(TextEditingController controller, String hint,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ✅ Auth Button
  Widget _authButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF00C853),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
