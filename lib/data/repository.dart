// lib/data/repository.dart

import 'package:client/models/sinistre.dart';

import 'mock_api_service.dart';
import '../models/user.dart';

class Repository {
  final MockApiService _apiService = MockApiService();

  Future<User?> getUserById(String userId) async {
    try {
      return await _apiService.getUserById(userId);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> createUser(User user) async {
    try {
      // Simulate user creation
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<List<Sinistre>?> getSinistres() async {
    try {
      return await _apiService.getSinistres();
    } catch (e) {
      print('Error fetching sinistres: $e');
      return null;
    }
  }
}
