import 'package:flutter/material.dart';
import '../../domain/entities/central_office_entity.dart';
import '../../domain/usecases/list_central_offices_usecase.dart';
import '../../domain/usecases/get_central_office_usecase.dart';
import '../../domain/usecases/create_central_office_usecase.dart';
import '../../domain/usecases/update_central_office_usecase.dart';
import '../../domain/usecases/delete_central_office_usecase.dart';

class CentralOfficeProvider extends ChangeNotifier {
  final ListCentralOfficesUseCase listCentralOfficesUseCase;
  final GetCentralOfficeUseCase getCentralOfficeUseCase;
  final CreateCentralOfficeUseCase createCentralOfficeUseCase;
  final UpdateCentralOfficeUseCase updateCentralOfficeUseCase;
  final DeleteCentralOfficeUseCase deleteCentralOfficeUseCase;

  CentralOfficeProvider({
    required this.listCentralOfficesUseCase,
    required this.getCentralOfficeUseCase,
    required this.createCentralOfficeUseCase,
    required this.updateCentralOfficeUseCase,
    required this.deleteCentralOfficeUseCase,
  });

  List<CentralOfficeEntity> _offices = [];
  List<CentralOfficeEntity> get offices => _offices;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadOffices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _offices = await listCentralOfficesUseCase.execute();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CentralOfficeEntity?> getOffice(int id) async {
    try {
      return await getCentralOfficeUseCase.execute(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await createCentralOfficeUseCase.execute(
        prefix: prefix,
        name: name,
        city: city,
        latitude: latitude,
        longitude: longitude,
      );
      await loadOffices();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await updateCentralOfficeUseCase.execute(
        officeId: officeId,
        prefix: prefix,
        name: name,
        city: city,
        latitude: latitude,
        longitude: longitude,
      );
      await loadOffices();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteOffice(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await deleteCentralOfficeUseCase.execute(id);
      _offices.removeWhere((o) => o.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
