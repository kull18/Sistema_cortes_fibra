import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color primaryBlue;
  final Color primaryBlueHover;
  final Color primaryBlueSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color placeholder;
  final Color borderStrong;
  final Color borderSubtle;
  final Color background;
  final Color surface;
  final Color cardHeaderBg;
  final Color surfaceMuted;
  final Color shadow;
  final Color statusRed;
  final Color statusGreen;
  final Color statusAmber;
  final Color onlineGreen;
  final Color connectivityBg;

  const AppColorScheme({
    required this.primaryBlue,
    required this.primaryBlueHover,
    required this.primaryBlueSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.placeholder,
    required this.borderStrong,
    required this.borderSubtle,
    required this.background,
    required this.surface,
    required this.cardHeaderBg,
    required this.surfaceMuted,
    required this.shadow,
    required this.statusRed,
    required this.statusGreen,
    required this.statusAmber,
    required this.onlineGreen,
    required this.connectivityBg,
  });

  static const light = AppColorScheme(
    primaryBlue: Color(0xFF0061E2),
    primaryBlueHover: Color(0xFF0052C2),
    primaryBlueSoft: Color(0x1A0061E2),
    textPrimary: Color(0xFF1E1F21),
    textSecondary: Color(0xFF444649),
    placeholder: Color(0xFF94A3B8),
    borderStrong: Color(0xFF8D8F92),
    borderSubtle: Color(0xFFA6A8AB),
    background: Color(0xFFF6F7F7),
    surface: Color(0xFFFFFFFF),
    cardHeaderBg: Color(0x33E8E9EA),
    surfaceMuted: Color(0x4DE8E9EA),
    shadow: Color(0x141E1F21),
    statusRed: Color(0xFFC9000C),
    statusGreen: Color(0xFF089428),
    statusAmber: Color(0xFFC97A00),
    onlineGreen: Color(0xFF1DD75B),
    connectivityBg: Color(0xFFDADCDE),
  );

  static const dark = AppColorScheme(
    primaryBlue: Color(0xFF4C8DFF),
    primaryBlueHover: Color(0xFF3B7AE8),
    primaryBlueSoft: Color(0x264C8DFF),
    textPrimary: Color(0xFFF5F6F7),
    textSecondary: Color(0xFFB0B3B8),
    placeholder: Color(0xFF6B7280),
    borderStrong: Color(0xFF3A3D42),
    borderSubtle: Color(0xFF2C2F33),
    background: Color(0xFF121316),
    surface: Color(0xFF1E2024),
    cardHeaderBg: Color(0x33FFFFFF),
    surfaceMuted: Color(0x1AFFFFFF),
    shadow: Color(0x66000000),
    statusRed: Color(0xFFFF6B60),
    statusGreen: Color(0xFF3DD68C),
    statusAmber: Color(0xFFFBBF24),
    onlineGreen: Color(0xFF34D399),
    connectivityBg: Color(0xFF2C2F33),
  );

  @override
  AppColorScheme copyWith({
    Color? primaryBlue,
    Color? primaryBlueHover,
    Color? primaryBlueSoft,
    Color? textPrimary,
    Color? textSecondary,
    Color? placeholder,
    Color? borderStrong,
    Color? borderSubtle,
    Color? background,
    Color? surface,
    Color? cardHeaderBg,
    Color? surfaceMuted,
    Color? shadow,
    Color? statusRed,
    Color? statusGreen,
    Color? statusAmber,
    Color? onlineGreen,
    Color? connectivityBg,
  }) {
    return AppColorScheme(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      primaryBlueHover: primaryBlueHover ?? this.primaryBlueHover,
      primaryBlueSoft: primaryBlueSoft ?? this.primaryBlueSoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      placeholder: placeholder ?? this.placeholder,
      borderStrong: borderStrong ?? this.borderStrong,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardHeaderBg: cardHeaderBg ?? this.cardHeaderBg,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      shadow: shadow ?? this.shadow,
      statusRed: statusRed ?? this.statusRed,
      statusGreen: statusGreen ?? this.statusGreen,
      statusAmber: statusAmber ?? this.statusAmber,
      onlineGreen: onlineGreen ?? this.onlineGreen,
      connectivityBg: connectivityBg ?? this.connectivityBg,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      primaryBlueHover: Color.lerp(primaryBlueHover, other.primaryBlueHover, t)!,
      primaryBlueSoft: Color.lerp(primaryBlueSoft, other.primaryBlueSoft, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardHeaderBg: Color.lerp(cardHeaderBg, other.cardHeaderBg, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      statusRed: Color.lerp(statusRed, other.statusRed, t)!,
      statusGreen: Color.lerp(statusGreen, other.statusGreen, t)!,
      statusAmber: Color.lerp(statusAmber, other.statusAmber, t)!,
      onlineGreen: Color.lerp(onlineGreen, other.onlineGreen, t)!,
      connectivityBg: Color.lerp(connectivityBg, other.connectivityBg, t)!,
    );
  }
}
