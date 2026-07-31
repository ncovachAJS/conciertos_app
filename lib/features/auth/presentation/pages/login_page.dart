import 'package:conciertos_app/l10n/generated/app_localizations.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    debugPrint('📧 email: "${_emailController.text.trim()}"');
    debugPrint('🔑 password length: ${_passwordController.text.length}');

    try {
      await _auth.login(
        email: _emailController.text
            .trim()
            .replaceAll('\n', '')
            .replaceAll('\r', ''),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ LOGIN ERROR: $e');

      String message = 'No se ha podido iniciar sesión.';
      final error = e.toString().toLowerCase();

      if (error.contains('incorrectos') || error.contains('unauthorized')) {
        message = 'Correo o contraseña incorrectos.';
      } else if (error.contains('timeout') || error.contains('timed out')) {
        message = 'El servidor tardó demasiado. Inténtalo de nuevo.';
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
        final l = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(l.loginTitle)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
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
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Introduce tu contraseña'
                        : null,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _auth.loading ? null : _forgotPassword,
                      child: Text(l.forgotPasswordLink),
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
                          : Text(l.loginTitle),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: _auth.loading
                        ? null
                        : () => context.push('/register'),
                    child: Text(l.noAccountSignUp),
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
