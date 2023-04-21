//auth_api_service.dart

import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../config.dart';

class AuthApiService {
  static const String baseUrl = Config.baseUrl;

  Future<User> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body:
          jsonEncode({'login': username, 'password': password, 'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return User(
        username: username,
        password: password,
        email: email,
        token: body['access_token'],
      );
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['detail']);
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'login': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return User(
        username: username,
        password: password,
        email: null, // email is not returned in the response
        token: body['access_token'],
      );
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['detail']);
    }
  }
}
