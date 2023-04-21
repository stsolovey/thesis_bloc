// courses_api_service.dart

import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'package:http/http.dart' as http;

import '../models/course_model.dart';
import '../config.dart';
import 'categories_api_service.dart';

class CoursesApiService {
  static const String baseUrl = Config.baseUrl;
  final CategoriesApiService _categoriesApiService = CategoriesApiService();

  Future<Map<String, dynamic>> getCourses(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_courses'),
      body: jsonEncode({"access_token": token, "token_type": "string"}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to fetch courses');
    }
  }

  CategoriesApiService get categoriesApiService => _categoriesApiService;
}
