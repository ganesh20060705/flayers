import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true; // Toggle between login & signup
  final _auth = FirebaseAuth.instance;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _redirectIfLoggedIn();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  // ✅ Auto redirect if user is already logged in
  void _redirectIfLoggedIn() {
    final user = _auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home_page");
        }
      });
    }
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

  // 🔹 Firebase error -> friendly message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _mapFirebaseCodeToMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return code;
    }
  }

  // 🔹 Unified authentication handler
  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final confirmPassword = confirmPassController.text.trim();
    final name = nameController.text.trim();

    _showLoading();

    try {
      UserCredential userCred;

      if (showLogin) {
        // LOGIN FLOW
        userCred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // SIGNUP FLOW
        if (password != confirmPassword) {
          throw const FormatException('Passwords do not match');
        }

        userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Update display name
        if (userCred.user != null && name.isNotEmpty) {
          await userCred.user!.updateDisplayName(name);
        }
      }

      // NAVIGATE TO HOME AFTER SUCCESS
      _hideLoadingIfOpen();
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/home_page");
      }
    } on FirebaseAuthException catch (e) {
      _hideLoadingIfOpen();
      _showError(_mapFirebaseCodeToMessage(e.code));
    } on FormatException catch (e) {
      _hideLoadingIfOpen();
     _showError(e.message ?? 'Invalid input.');

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
              _textField(confirmPassController, "Confirm Password", obscure: true),
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
