import 'package:client/models/sinistre.dart';
import 'package:client/data/api_service.dart';
import 'package:flutter/material.dart';

class SinistreViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Sinistre> _sinistres = [];
  Sinistre? _selectedSinistre;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Sinistre> get sinistres => _sinistres;
  Sinistre? get selectedSinistre => _selectedSinistre;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSinistres() async {
    _setLoading(true);
    try {
      _sinistres = await _apiService.getSinistres();
    } catch (e) {
      _setErrorMessage('Failed to fetch sinistres');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchSinistreById(String id) async {
    _setLoading(true);
    try {
      _selectedSinistre = await _apiService.getSinistreById(id);
    } catch (e) {
      _setErrorMessage('Failed to fetch sinistre');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createSinistre(Sinistre sinistre) async {
    _setLoading(true);
    try {
      await _apiService.createSinistre(sinistre);
      await fetchSinistres();
    } catch (e) {
      _setErrorMessage('Failed to create sinistre');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSinistre(String id, Sinistre sinistre) async {
    _setLoading(true);
    try {
      await _apiService.updateSinistre(id, sinistre);
      await fetchSinistres();
    } catch (e) {
      _setErrorMessage('Failed to update sinistre');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSinistre(String id) async {
    _setLoading(true);
    try {
      await _apiService.deleteSinistre(id);
      await fetchSinistres();
    } catch (e) {
      _setErrorMessage('Failed to delete sinistre');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
