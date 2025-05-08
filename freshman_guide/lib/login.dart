import 'package:flutter/material.dart';
import 'package:freshman_guide/shared/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

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

  Future<void> _handleSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<SigninProvider>(context, listen: false);
      final success = await provider.signinUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        // Navigate to home screen or desired destination
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SigninProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed:
                      provider.isLoading ? null : () => _handleSignIn(context),
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign In'),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to password reset screen
                    Navigator.pushNamed(context, '/reset-password');
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
