import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/biometric_button.dart';
import '../widgets/login_card_header.dart';
import '../widgets/or_divider.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_login_button.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/technician_id_field.dart';
import '../providers/auth_provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  /// Orquestador central de navegación post-autenticación.
  /// Define el flujo: 1. Completar Perfil -> 2. Cambiar Contraseña -> 3. Home.
  static void navigateNext(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    if (user == null) return;

    if (!user.profileCompleted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.completeProfile);
    } else if (user.mustChangePassword) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.changePassword);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  void _handleLogin(BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.login();
    if (!context.mounted) return;

    if (success) {
      navigateNext(context, authProvider);
    } else {
      _showError(context, authProvider.errorMessage);
    }
  }

  void _handleBiometricLogin(BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.biometricLogin();
    if (!context.mounted) return;

    if (success) {
      navigateNext(context, authProvider);
    } else if (authProvider.errorMessage != null) {
      _showError(context, authProvider.errorMessage);
    }
  }

  void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Error inesperado'),
        backgroundColor: AppColors.statusRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cardPadding = context.responsiveValue<double>(small: 12.0, medium: 16.0);
    final outerPadding = context.responsiveValue<double>(small: 12.0, medium: 16.0);

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
                    padding: EdgeInsets.all(outerPadding),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - (outerPadding * 2)).clamp(0.0, double.infinity),
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
                                padding: EdgeInsets.all(cardPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TechnicianIdField(
                                      controller: authProvider.technicianCodeController,
                                    ),
                                    const SizedBox(height: 20),
                                    PasswordField(
                                      controller: authProvider.passwordController,
                                      onForgotPassword: () => _handleForgotPassword(context),
                                    ),
                                    const SizedBox(height: 16),
                                    RememberMeCheckbox(
                                      value: authProvider.rememberMe,
                                      onChanged: (value) => authProvider.setRememberMe(value),
                                    ),
                                    const SizedBox(height: 20),
                                    PrimaryLoginButton(
                                      isLoading: authProvider.isLoading,
                                      onPressed: () => _handleLogin(context, authProvider),
                                    ),
                                    const OrDivider(label: 'o acceso alternativo'),
                                    BiometricButton(
                                      onPressed: () => _handleBiometricLogin(context, authProvider),
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
