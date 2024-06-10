import 'dart:convert';
import 'package:client/models/sinistre.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.16:3000/api'; // Replace with your server address

  // Helper method to get the token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Create a new sinistre
  Future<Sinistre?> createSinistre(Sinistre sinistre) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/sinistres'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sinistre.toJson()),
    );

    if (response.statusCode == 201) {
      return Sinistre.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to create sinistre: ${response.body}');
      throw Exception('Failed to create sinistre');
    }
  }

  // Get all sinistres
  Future<List<Sinistre>> getSinistres() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/sinistres'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((sinistre) => Sinistre.fromJson(sinistre)).toList();
    } else if (response.statusCode == 401) {
      print('Unauthorized access: ${response.body}');
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      print('Failed to load sinistres: ${response.body}');
      throw Exception('Failed to load sinistres');
    }
  }

  // Get a sinistre by ID
  Future<Sinistre?> getSinistreById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/sinistres/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Sinistre.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print('Unauthorized access: ${response.body}');
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      print('Failed to load sinistre: ${response.body}');
      throw Exception('Failed to load sinistre');
    }
  }

  // Update a sinistre by ID
  Future<Sinistre?> updateSinistre(String id, Sinistre sinistre) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/sinistres/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sinistre.toJson()),
    );

    if (response.statusCode == 200) {
      return Sinistre.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print('Unauthorized access: ${response.body}');
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      print('Failed to update sinistre: ${response.body}');
      throw Exception('Failed to update sinistre');
    }
  }

  // Delete a sinistre by ID
  Future<void> deleteSinistre(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/sinistres/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      print('Unauthorized access: ${response.body}');
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      print('Failed to delete sinistre: ${response.body}');
      throw Exception('Failed to delete sinistre');
    }
  }
}
