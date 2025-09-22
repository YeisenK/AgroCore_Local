// lib/pages/login.dart
import 'package:flutter/material.dart';
import '../main.dart' show Routes;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // Simula delay de login
    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => _loading = false);
    if (!mounted) return;

    // Ir al dashboard de ingeniero
    Navigator.pushReplacementNamed(context, Routes.engineer);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF1F2A30),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            color: const Color(0xFF2A343B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFF42535B), width: 1),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bienvenido de nuevo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD9E1E8),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Por favor ingresa los datos de tu cuenta',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFAEB8BF),
                          ),
                    ),
                    const SizedBox(height: 28),

                    // Usuario
                    TextFormField(
                      controller: _userCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        hintText: 'Introduce tu usuario',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Escribe tu usuario' : null,
                    ),
                    const SizedBox(height: 16),

                    // Contraseña
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Introduce tu contraseña',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Escribe tu contraseña' : null,
                    ),
                    const SizedBox(height: 22),

                    // Botón
                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Ingresar'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Enlace recuperar
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Aquí pondrías tu lógica de recuperar contraseña
                        },
                        child: Text(
                          '¿No recuerdas tu contraseña?',
                          style: TextStyle(color: cs.secondary),
                        ),
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
