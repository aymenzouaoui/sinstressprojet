import 'dart:convert';
import '../models/user.dart';
import '../models/sinistre.dart';

class MockApiService {
  Future<User> getUserById(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    final userJson = jsonEncode({
      'id': userId,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phoneNumber': '123-456-7890',
    });
    return User.fromJson(jsonDecode(userJson));
  }

  Future<List<Sinistre>> getSinistres() async {
    await Future.delayed(const Duration(seconds: 2));
    final sinistresJson = jsonEncode([
      {
        'id': '1',
        'userId': '123',
        'description': 'Accident de voiture',
        'status': 'En cours',
        'location': 'Paris, France',
        'photos': ['url1', 'url2'],
        'dateReported': DateTime.now().toIso8601String(),
        'car': {
          'id': 'car1',
          'make': 'Toyota',
          'model': 'Corolla',
          'year': 2020,
          'licensePlate': 'ABC-1234',
        }
      },
      {
        'id': '2',
        'userId': '123',
        'description': 'Vol de voiture',
        'status': 'Résolu',
        'location': 'Lyon, France',
        'photos': ['url3', 'url4'],
        'dateReported': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'car': {
          'id': 'car2',
          'make': 'Honda',
          'model': 'Civic',
          'year': 2018,
          'licensePlate': 'XYZ-5678',
        }
      }
    ]);
    List<dynamic> sinistresList = jsonDecode(sinistresJson);
    return sinistresList.map((json) => Sinistre.fromJson(json)).toList();
  }
}
