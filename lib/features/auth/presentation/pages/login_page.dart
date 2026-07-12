import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthController auth = AuthController.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    try {
                      await auth.login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );

                      debugPrint('Usuario: ${auth.user?.name}');
                      debugPrint('Email: ${auth.user?.email}');
                      debugPrint('Token: ${auth.token}');

                      if (!mounted) return;

                      context.go('/splash');
                    } catch (e) {
                      if (!mounted) return;

                      String message = 'No se ha podido iniciar sesión.';

                      final error = e.toString().toLowerCase();

                      if (error.contains('incorrectos')) {
                        message = 'Correo o contraseña incorrectos.';
                      } else if (error.contains('unauthorized')) {
                        message = 'Correo o contraseña incorrectos.';
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  },
                  child: auth.loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Iniciar sesión"),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: const Text('¿No tienes cuenta? Crear una cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
