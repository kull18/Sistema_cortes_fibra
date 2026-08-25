import '../../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      technicianCode: model.technicianCode,
      fullName: model.fullName,
      role: model.role,
      email: model.email,
      jobTitle: model.jobTitle,
      profilePhotoUrl: model.profilePhotoUrl,
      mustChangePassword: model.mustChangePassword,
      profileCompleted: model.profileCompleted,
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      technicianCode: entity.technicianCode,
      fullName: entity.fullName,
      role: entity.role,
      email: entity.email,
      jobTitle: entity.jobTitle,
      profilePhotoUrl: entity.profilePhotoUrl,
      mustChangePassword: entity.mustChangePassword,
      profileCompleted: entity.profileCompleted,
    );
  }
}
