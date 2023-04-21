//categories_api_service.dart

import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../config.dart';

class CategoriesApiService {
  static const String baseUrl = Config.baseUrl;

  Future<List<dynamic>> getCategories(String token, String courseId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/choose_course?course_id=$courseId'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({'access_token': token, 'token_type': 'string'}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
