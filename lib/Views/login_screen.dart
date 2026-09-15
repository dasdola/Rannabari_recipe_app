import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rannabari_recipe_app/Provider/auth_provider.dart';
import 'package:rannabari_recipe_app/Views/register_screen.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pop(context); // go back to Settings screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ), // AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ), // TextStyle
              ), // Text
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ), // TextStyle
              ), // Text
              const SizedBox(height: 32),

              // email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ), // InputDecoration
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email";
                  }
                  if (!value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ), // TextFormField
              const SizedBox(height: 16),

              // password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ), // IconButton
                ), // InputDecoration
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ), // TextFormField

              if (authProvider.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ), // Text
              ],

              const SizedBox(height: 28),

              // login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarycolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), // RoundedRectangleBorder
                  ),
                  onPressed: authProvider.isLoading
                      ? null
                      : () => _handleLogin(authProvider),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ), // CircularProgressIndicator
                        ) // SizedBox
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ), // TextStyle
                        ), // Text
                ), // ElevatedButton
              ), // SizedBox

              const SizedBox(height: 16),

              // go to register
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ), // MaterialPageRoute
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ), // TextStyle
                        ), // TextSpan
                      ],
                    ), // TextSpan
                  ), // Text.rich
                ), // TextButton
              ), // Center
            ],
          ), // Column
        ), // Form
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
