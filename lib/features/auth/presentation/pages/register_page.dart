import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme_picker_page.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _auth = AuthController.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _auth.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Resetear el flag para que la splash se muestre en el primer inicio
      // después del registro (experiencia de bienvenida completa)
      // Cuenta nueva: resetear splash y tutoriales para experiencia completa
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenSplash', false);
      await TutorialService.resetAll();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ThemePickerPage()),
      );
    } catch (e) {
      if (!mounted) return;

      final l = AppLocalizations.of(context);
      String message = l.registerErrorGeneric;
      final error = e.toString().toLowerCase();

      if (error.contains('email must be an email')) {
        message = l.registerErrorInvalidEmail;
      } else if (error.contains('already') || error.contains('ya existe')) {
        message = l.registerErrorEmailTaken;
      } else if (error.contains('password')) {
        message = l.registerErrorInvalidPassword;
      } else if (error.contains('timeout') || error.contains('timed out')) {
        message = l.serverTimeout;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        final l = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(l.registerTitle)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.usernameLabel,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l.usernameRequired
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l.emailLabel,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l.emailRequired
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l.passwordLabel,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? l.passwordMinLength
                        : null,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _auth.loading ? null : _register,
                      child: _auth.loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l.registerTitle),
                    ),
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
