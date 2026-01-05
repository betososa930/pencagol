// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/preferences_service.dart';
import '../utils/app_strings.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberUser = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final savedEmail = await PreferencesService.getSavedEmail();
    final isRemembered = await PreferencesService.isRememberUserEnabled();

    if (savedEmail != null && isRemembered) {
      setState(() {
        _usernameController.text = savedEmail;
        _rememberUser = true;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithGoogle() async {
    HapticFeedback.lightImpact();
    try {
      await AuthService.instance.signInWithGoogle();
      // StreamBuilder en main.dart llevará al Home automáticamente
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    }
  }

  Future<void> _loginWithApple() async {
    HapticFeedback.lightImpact();
    try {
      await AuthService.instance.signInWithApple();
      // StreamBuilder en main.dart llevará al Home automáticamente
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      try {
        await AuthService.instance.signInWithEmail(
          email: _usernameController.text.trim(),
          password: _passwordController.text,
        );

        // Guardar email si marcó "Recordar usuario"
        if (_rememberUser) {
          await PreferencesService.saveEmail(_usernameController.text.trim());
          await PreferencesService.setRememberUser(true);
        } else {
          await PreferencesService.clearSavedUser();
        }
        // StreamBuilder en main.dart llevará al Home automáticamente
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    }
  }

  void _goToRegister() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    HapticFeedback.lightImpact();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Recuperar Contraseña'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ingresa tu email y recibirás un enlace para restablecer tu contraseña.',
                  style: TextStyle(color: AppTheme.darkGrey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          await AuthService.instance.sendPasswordResetEmail(
                              emailController.text.trim());
                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Se envió un enlace de recuperación a tu email. Revisa tu bandeja.'),
                              backgroundColor: AppTheme.primaryGreen,
                              duration: Duration(seconds: 4),
                            ),
                          );
                        } catch (error) {
                          setState(() => isLoading = false);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              backgroundColor: AppTheme.accentOrange,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentOrange,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                    )
                  : const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen,
              AppTheme.accentBlue,
              AppTheme.primaryGreen,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título y subtítulo
                  const Text(
                    'PencaGol',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  // Tarjeta de login
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.blackAccent.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.blackAccent,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Elige tu forma de iniciar sesión',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Botón de Google mejorado
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _loginWithGoogle,
                              icon: const Icon(Icons.g_mobiledata, size: 22),
                              label: const Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentOrange,
                                foregroundColor: AppTheme.white,
                                elevation: 8,
                                shadowColor:
                                    AppTheme.accentOrange.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón de Apple
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _loginWithApple,
                              icon: const Icon(Icons.apple, size: 22),
                              label: const Text(
                                'Apple ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.blackAccent,
                                foregroundColor: AppTheme.white,
                                elevation: 8,
                                shadowColor:
                                    AppTheme.blackAccent.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Divisor
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppTheme.lightGrey,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'o',
                                  style: TextStyle(
                                    color: AppTheme.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppTheme.lightGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Campo de usuario
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              hintText: 'Ingresa tu usuario',
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppTheme.accentOrange,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu usuario';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Campo de contraseña
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Ingresa tu contraseña',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppTheme.accentOrange,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppTheme.accentOrange,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          // Checkbox "Recordar usuario"
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberUser,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberUser = value ?? false;
                                  });
                                },
                                activeColor: AppTheme.accentOrange,
                              ),
                              Text(
                                AppStrings.rememberUser,
                                style: TextStyle(
                                  color: AppTheme.darkGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Botón de login alternativo
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Link de contraseña olvidada
                          TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: AppTheme.accentOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Link de registro
                          TextButton(
                            onPressed: _goToRegister,
                            child: const Text(
                              '¿No tienes cuenta? Regístrate aquí',
                              style: TextStyle(
                                color: AppTheme.accentOrange,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
