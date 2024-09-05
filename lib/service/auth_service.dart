import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madaride/utils/file_secure_storage.dart';

class AuthService {
  final fileStorage = SecureStorage();
  final String baseUrl = 'http://172.20.10.9:8000/api';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final token = data['token'];
      fileStorage.saveToken(token);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {'username': username, 'password': password, 'email': email},
    );

    return response.statusCode == 201;
  }

  Future<void> logout() async {
    await fileStorage.deleteToken();
  }

  Future<String?> refreshToken() async {
    String? oldToken = fileStorage.getToken() as String?;
    if (oldToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: {'Authorization': 'Bearer $oldToken'},
      );

      if (response.statusCode == 200) {
        final newToken = json.decode(response.body)['token'];
        fileStorage.saveToken(newToken);
        return newToken;
      }
    } catch (e) {
      print('Erreur lors du rafraîchissement du token: $e');
    }
    return null;
  }
}