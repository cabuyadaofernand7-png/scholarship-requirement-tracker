
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  const LoginPage({
    super.key,
    required this.apiService,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  String? errorMessage;

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await widget.apiService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      final user = result['user'];
      final role = user['role']?['name'];

      if (role != 'student') {
        await widget.apiService.logout();

        setState(() {
          errorMessage =
          'This dashboard is currently available to student accounts only.';
          isLoading = false;
        });
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            apiService: widget.apiService,
            user: user,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school,
                      size: 55,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Scholarship Requirement Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Sign in to your student account'),
                    const SizedBox(height: 28),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),

                    if (errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleLogin,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
