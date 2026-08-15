import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Avatar del técnico con indicador de estado (online), compartido
/// entre el header y la screen de Perfil.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool showStatusDot;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.size = 32,
    this.showStatusDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: imageUrl != null
                ? Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
                : _fallback(),
          ),
          if (showStatusDot)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: AppColors.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      color: AppColors.primaryBlueSoft,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: AppColors.primaryBlue,
      ),
    );
  }
}