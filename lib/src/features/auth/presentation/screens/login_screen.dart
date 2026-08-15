import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/biometric_button.dart';
import '../widgets/login_card_header.dart';
import '../widgets/or_divider.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_login_button.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/technician_id_field.dart';

import '../../../../core/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _technicianIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _technicianIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  void _handleBiometricLogin() {
    // TODO: integrar local_auth
  }

  void _handleForgotPassword() {
    // TODO: navegar a recuperación de contraseña
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'FiberTech Ops'),
            const Divider(height: 1, color: AppColors.borderSubtle),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 32,
                      ),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const LoginCardHeader(
                                title: 'Iniciar Sesión',
                                subtitle: 'Ingrese sus credenciales de técnico para operar',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TechnicianIdField(
                                      controller: _technicianIdController,
                                    ),
                                    const SizedBox(height: 20),
                                    PasswordField(
                                      controller: _passwordController,
                                      onForgotPassword: _handleForgotPassword,
                                    ),
                                    const SizedBox(height: 16),
                                    RememberMeCheckbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() => _rememberMe = value);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    PrimaryLoginButton(
                                      isLoading: _isLoading,
                                      onPressed: _handleLogin,
                                    ),
                                    const OrDivider(label: 'o acceso alternativo'),
                                    BiometricButton(
                                      onPressed: _handleBiometricLogin,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
