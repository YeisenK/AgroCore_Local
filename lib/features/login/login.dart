import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../app/data/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final ok = await auth.doLogin(_idCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;

    if (ok) {
      context.go(auth.preferredHome());
    } else {
      const msg = 'ID o contraseña incorrectos';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loading =
        context.watch<AuthController>().status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: cs.outline, width: 1),
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
                      'Bienvenido a AgroCore',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ingresa tu ID y contraseña',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),

                    // ID FIELD
                    TextFormField(
                      controller: _idCtrl,
                      style: TextStyle(color: cs.onSurface),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.username],
                      decoration: InputDecoration(
                        labelText: 'ID de usuario',
                        hintText: 'Ejemplo: 10234',
                        labelStyle: TextStyle(color: cs.onSurfaceVariant),
                        hintStyle: TextStyle(color: cs.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.outline),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.primary),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Escribe tu ID';
                        }
                        if (!RegExp(r'^\d{5}$').hasMatch(v.trim())) {
                          return 'El ID debe tener 5 números';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    TextFormField(
                      controller: _passCtrl,
                      style: TextStyle(color: cs.onSurface),
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _submit(),
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: cs.onSurfaceVariant),
                        hintStyle: TextStyle(color: cs.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.outline),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.primary),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: cs.onSurfaceVariant,
                          ),
                          tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Escribe tu contraseña' : null,
                    ),
                    const SizedBox(height: 22),

                    // BUTTON
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Ingresar'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '¿Olvidaste tu contraseña?',
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