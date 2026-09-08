import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/device_login_usecase.dart';
import '../../domain/usecases/register_device_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../domain/usecases/get_profile_photo_upload_url_usecase.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/api/biometric_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeviceLoginUseCase _deviceLoginUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final CompleteProfileUseCase _completeProfileUseCase;
  final GetProfilePhotoUploadUrlUseCase _getProfilePhotoUploadUrlUseCase;
  final StorageService _storageService;
  final UserService _userService;
  final BiometricAuthService _biometricAuthService;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required DeviceLoginUseCase deviceLoginUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required CompleteProfileUseCase completeProfileUseCase,
    required GetProfilePhotoUploadUrlUseCase getProfilePhotoUploadUrlUseCase,
    required StorageService storageService,
    required UserService userService,
    required BiometricAuthService biometricAuthService,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _deviceLoginUseCase = deviceLoginUseCase,
        _registerDeviceUseCase = registerDeviceUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _completeProfileUseCase = completeProfileUseCase,
        _getProfilePhotoUploadUrlUseCase = getProfilePhotoUploadUrlUseCase,
        _storageService = storageService,
        _userService = userService,
        _biometricAuthService = biometricAuthService {
    _loadSavedTechnicianId();
  }

  // Form State
  final technicianCodeController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;

  // Obtenemos el usuario directamente del UserService para mantener sincronía
  UserEntity? get user => _userService.currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  Future<void> _loadSavedTechnicianId() async {
    final savedId = await _storageService.getTechnicianId();
    if (savedId != null && savedId.isNotEmpty) {
      technicianCodeController.text = savedId;
      _rememberMe = true;
    } else {
      technicianCodeController.clear();
      _rememberMe = false;
    }
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    if (!value) {
      _storageService.clearTechnicianId();
    } else if (technicianCodeController.text.trim().isNotEmpty) {
      _storageService.saveTechnicianId(technicianCodeController.text.trim());
    }
    notifyListeners();
  }

  Future<bool> login() async {
    final code = technicianCodeController.text.trim();
    final pass = passwordController.text;

    if (code.isEmpty || pass.isEmpty) {
      _errorMessage = 'Por favor, complete todos los campos';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loginUseCase(
        technicianCode: code,
        password: pass,
      );

      if (_rememberMe) {
        await _storageService.saveTechnicianId(code);
        await registerDevice(deviceLabel: 'Dispositivo Técnico');
      } else {
        await _storageService.clearTechnicianId();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> biometricLogin() async {
    final deviceToken = await _storageService.getDeviceToken();
    if (deviceToken == null) {
      _errorMessage = 'Debe iniciar sesión con contraseña al menos una vez para activar la biometría.';
      notifyListeners();
      return false;
    }

    final isAvailable = await _biometricAuthService.isAvailable();
    if (!isAvailable) {
      _errorMessage = 'La autenticación biométrica no está disponible en este dispositivo.';
      notifyListeners();
      return false;
    }

    final authenticated = await _biometricAuthService.authenticate();
    if (!authenticated) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deviceLoginUseCase(deviceToken: deviceToken);
      if (_rememberMe && user?.technicianCode != null && user!.technicianCode.isNotEmpty) {
        await _storageService.saveTechnicianId(user!.technicianCode);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerDevice({String? deviceLabel}) async {
    try {
      await _registerDeviceUseCase(deviceLabel: deviceLabel);
      return true;
    } catch (e) {
      debugPrint('Error registrando dispositivo: \$e');
      return false;
    }
  }

  Future<bool> forgotPassword(String technicianCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _forgotPasswordUseCase(technicianCode: technicianCode);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    File? profileImage,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? objectKey;

      if (profileImage != null) {
        final filename = profileImage.path.split('/').last;
        
        final uploadData = await _getProfilePhotoUploadUrlUseCase(filename: filename);
        final uploadUrl = uploadData['upload_url'] as String;
        objectKey = uploadData['object_key'] as String;

        final bytes = await profileImage.readAsBytes();
        final response = await http.put(
          Uri.parse(uploadUrl),
          body: bytes,
          headers: {
            'Content-Length': bytes.length.toString(),
          },
        );

        if (response.statusCode != 200) {
          throw Exception('No se pudo subir la foto de perfil');
        }
      }

      await _completeProfileUseCase(
        fullName: fullName,
        email: email,
        jobTitle: jobTitle,
        profilePhotoKey: objectKey,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _logoutUseCase();
      passwordController.clear();
      await _loadSavedTechnicianId();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _changePasswordUseCase(newPassword: newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    technicianCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
