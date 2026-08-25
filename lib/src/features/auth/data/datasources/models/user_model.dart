import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? accessToken;
  final String? tokenType;

  UserModel({
    required super.id,
    required super.technicianCode,
    required super.fullName,
    required super.role,
    required super.mustChangePassword,
    required super.profileCompleted,
    super.email,
    super.jobTitle,
    super.profilePhotoUrl,
    this.accessToken,
    this.tokenType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    
    // Extraemos los flags de control. 
    // must_change_password suele venir en la raíz del LoginResponse.
    // profile_completed viene dentro del objeto user.
    return UserModel(
      id: userJson['id']?.toString() ?? '',
      technicianCode: userJson['technician_code'] ?? '',
      fullName: userJson['full_name'] ?? 'Técnico SCF',
      role: userJson['role'] ?? 'TECNICO',
      email: userJson['email'],
      jobTitle: userJson['job_title'],
      profilePhotoUrl: userJson['profile_photo_url'],
      mustChangePassword: json['must_change_password'] ?? false,
      profileCompleted: userJson['profile_completed'] ?? false, // Por defecto false para obligar a completar
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'must_change_password': mustChangePassword,
      'user': {
        'id': id,
        'technician_code': technicianCode,
        'full_name': fullName,
        'role': role,
        'email': email,
        'job_title': jobTitle,
        'profile_photo_url': profilePhotoUrl,
        'profile_completed': profileCompleted,
      },
    };
  }
}
