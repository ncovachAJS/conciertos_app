import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _auth = AuthController.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      context.go('/splash');
    } catch (e) {
      if (!mounted) return;

      String message = 'No se ha podido iniciar sesión.';
      final error = e.toString().toLowerCase();

      if (error.contains('incorrectos') || error.contains('unauthorized')) {
        message = 'Correo o contraseña incorrectos.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _forgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Iniciar sesión')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Introduce tu correo'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Introduce tu contraseña'
                        : null,
                  ),

                  // ── ¿Olvidaste tu contraseña? ──────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _auth.loading ? null : _forgotPassword,
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _auth.loading ? null : _login,
                      child: _auth.loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: _auth.loading
                        ? null
                        : () => context.push('/register'),
                    child: const Text('¿No tienes cuenta? Crear una cuenta'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
