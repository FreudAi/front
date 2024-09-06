import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:madaride/utils/file_secure_storage.dart';

import '../model/user.dart';
import '../utils/http_interceptor.dart';

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



  Future<User> profile() async {
    final client = InterceptedClient.build(
      interceptors: [AuthInterceptor()],
    );

    final response = await client.get(
      Uri.parse('$baseUrl/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return User.fromJson(body);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<bool> logout() async {
    final client = InterceptedClient.build(
      interceptors: [AuthInterceptor()],
    );

    final response = await client.post(
      Uri.parse('$baseUrl/logout'),
      body: {},
    );

    if (response.statusCode == 200) {
      await fileStorage.deleteToken();
      return true;
    }

    return false;
  }

  Future<String?> refreshToken() async {
    String? oldToken = fileStorage.getToken() as String?;
    if (oldToken == null) return null;

    final client = InterceptedClient.build(
      interceptors: [AuthInterceptor()],
    );

    try {
      final response = await client.post(
        Uri.parse('$baseUrl/refresh'),
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