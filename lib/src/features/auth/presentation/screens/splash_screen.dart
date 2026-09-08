import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/src/core/app_colors.dart';
import 'package:sistema_cortes_fibra/src/core/responsive/responsive_extensions.dart';
import 'package:sistema_cortes_fibra/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:sistema_cortes_fibra/src/features/auth/presentation/screens/login_screen.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final Widget nextScreen = authProvider.user != null
        ? const HomeScreen()
        : const LoginScreen();

    final splashIconSize = context.responsiveValue<double>(
      small: 260.0,
      medium: 310.0,
      large: 340.0,
    );

    return AnimatedSplashScreen(
      duration: 2600,
      splashIconSize: splashIconSize,
      splash: const _SplashContent(),
      nextScreen: nextScreen,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: AppColors.background,
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _iconRotation;

  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;

  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleOpacity;

  late final Animation<double> _dotsOpacity;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Icono: entra con rebote (0% - 55% del tiempo total)
    _iconScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    _iconRotation = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Título: desliza hacia arriba mientras aparece (35% - 65%)
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // Subtítulo: mismo patrón, un poco después (55% - 85%)
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
      ),
    );

    // Puntos de carga: aparecen al final (80% - 100%)
    _dotsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconPadding = context.responsiveValue<double>(
      small: 16.0,
      medium: 24.0,
    );
    final iconSize = context.responsiveValue<double>(
      small: 60.0,
      medium: 80.0,
    );
    final spacingHeight = context.responsiveValue<double>(
      small: 20.0,
      medium: 32.0,
    );
    final titleFontSize = context.responsiveValue<double>(
      small: 22.0,
      medium: 28.0,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _entryController,
          builder: (context, child) {
            return Opacity(
              opacity: _iconOpacity.value,
              child: Transform.rotate(
                angle: _iconRotation.value,
                child: Transform.scale(
                  scale: _iconScale.value,
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueSoft,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/ic_network_node.svg',
              width: iconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(height: spacingHeight),

        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleOpacity,
            child: Text(
              'FiberTech Ops',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryBlue,
                letterSpacing: -1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SlideTransition(
          position: _subtitleSlide,
          child: FadeTransition(
            opacity: _subtitleOpacity,
            child: Text(
              'SISTEMA DE GESTIÓN DE CORTES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        FadeTransition(
          opacity: _dotsOpacity,
          child: const _LoadingDots(),
        ),
      ],
    );
  }
}

/// Tres puntos con animación de rebote secuencial, simulando "cargando".
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final t = (_controller.value - delay) % 1.0;
            final bounce = t < 0.5
                ? Curves.easeOut.transform(t * 2)
                : Curves.easeIn.transform(1 - (t - 0.5) * 2);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.translate(
                offset: Offset(0, -6 * bounce),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.4 + bounce * 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
