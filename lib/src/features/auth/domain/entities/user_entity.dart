class UserEntity {
  final String id;
  final String technicianCode;
  final String fullName;
  final String role;
  final String? email;
  final String? jobTitle;
  final String? profilePhotoUrl;
  final bool mustChangePassword;
  final bool profileCompleted;

  const UserEntity({
    required this.id,
    required this.technicianCode,
    required this.fullName,
    required this.role,
    required this.mustChangePassword,
    required this.profileCompleted,
    this.email,
    this.jobTitle,
    this.profilePhotoUrl,
  });

  UserEntity copyWith({
    String? id,
    String? technicianCode,
    String? fullName,
    String? role,
    String? email,
    String? jobTitle,
    String? profilePhotoUrl,
    bool? mustChangePassword,
    bool? profileCompleted,
  }) {
    return UserEntity(
      id: id ?? this.id,
      technicianCode: technicianCode ?? this.technicianCode,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      email: email ?? this.email,
      jobTitle: jobTitle ?? this.jobTitle,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }
}
