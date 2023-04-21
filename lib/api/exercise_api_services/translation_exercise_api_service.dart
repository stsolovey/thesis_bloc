// translation_exercise_api_service.dart
import '../../config.dart';
import 'base_exercise_api_service.dart';
import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'package:http/http.dart' as http;

class TranslationExerciseApiService extends BaseExerciseApiService {
  static const String baseUrl = Config.baseUrl;
  Future<Map<String, dynamic>> getExercise(
      String token, String categoryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_exercise?category_id=$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'access_token': token,
        'token_type': 'string',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  // ... any other translation exercise-specific methods or properties
}
