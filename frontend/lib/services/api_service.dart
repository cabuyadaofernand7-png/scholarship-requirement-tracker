
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  String? token;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      token = result['token'] as String;
      return result as Map<String, dynamic>;
    }

    throw Exception(
      result['message'] ?? 'Login failed.',
    );
  }

  Future<void> logout() async {
    if (token == null) return;

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    token = null;
  }

  Future<List<dynamic>> getNotifications() async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result['data']['data'] as List<dynamic>;
    }

    throw Exception(
      'Failed to load notifications. Status: ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> uploadDocument({
    required int applicationId,
    required int requiredDocumentId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/applications/$applicationId/documents'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['required_document_id'] =
        requiredDocumentId.toString();

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final result = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return result as Map<String, dynamic>;
    }

    throw Exception(
      result['message'] ?? 'Document upload failed.',
    );
  }
  Future<Map<String, dynamic>> submitApplication({
    required int applicationId,
  }) async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/applications/$applicationId/submit'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result as Map<String, dynamic>;
    }

    throw Exception(
      result['message'] ?? 'Application submission failed.',
    );
  }
}
