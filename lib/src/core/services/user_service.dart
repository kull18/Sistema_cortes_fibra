import '../../features/auth/domain/entities/user_entity.dart';
import 'storage_service.dart';

class UserService {
  final StorageService _storage;
  UserEntity? _currentUser;

  UserService(this._storage);

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void setCurrentUser(UserEntity user) {
    _currentUser = user;
  }

  Future<void> clear() async {
    _currentUser = null;
    await _storage.deleteToken();
  }
}
