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
      body: jsonEncode({'email': email, 'password': password}),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      token = result['token'] as String;
      return result as Map<String, dynamic>;
    }

    throw Exception(result['message'] ?? 'Login failed.');
  }

  Future<void> logout() async {
    if (token == null) return;

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    token = null;
  }

  Future<List<dynamic>> getApplications() async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/applications'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result['applications'] as List<dynamic>;
    }

    throw Exception(result['message'] ?? 'Failed to load applications.');
  }

  Future<List<dynamic>> getScholarshipPrograms() async {
    return _getList('/scholarship-programs', 'programs');
  }

  Future<Map<String, dynamic>> createApplication({
    required int scholarshipProgramId,
  }) async {
    final response = await _authorizedJsonRequest('POST', '/applications', {
      'scholarship_program_id': scholarshipProgramId,
    });
    final result = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return result as Map<String, dynamic>;
    }
    throw Exception(result['message'] ?? 'Application creation failed.');
  }

  Future<List<dynamic>> getStaffApplications() async {
    return _getList('/staff/applications', 'applications');
  }

  Future<List<dynamic>> getReviewerApplications() async {
    return _getList('/reviewer/applications', 'applications');
  }

  Future<List<dynamic>> getReviewers() async {
    return _getList('/staff/reviewers', 'reviewers');
  }

  Future<List<dynamic>> _getList(String path, String key) async {
    if (token == null) throw Exception('Please log in first.');

    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result[key] as List<dynamic>;
    }
    throw Exception(result['message'] ?? 'Unable to load data.');
  }

  Future<void> assignReviewer({
    required int applicationId,
    required int reviewerId,
  }) async {
    final response = await _authorizedJsonRequest(
      'POST',
      '/applications/$applicationId/assign-reviewer',
      {'reviewer_id': reviewerId},
    );
    if (response.statusCode != 201) {
      throw Exception(
        response.body.isEmpty
            ? 'Reviewer assignment failed.'
            : (jsonDecode(response.body)['message'] ??
                  'Reviewer assignment failed.'),
      );
    }
  }

  Future<void> updateApplicationStatus({
    required int applicationId,
    required String status,
  }) async {
    final response = await _authorizedJsonRequest(
      'PATCH',
      '/applications/$applicationId/status',
      {'status': status},
    );
    if (response.statusCode != 200) {
      throw Exception(
        response.body.isEmpty
            ? 'Status update failed.'
            : (jsonDecode(response.body)['message'] ?? 'Status update failed.'),
      );
    }
  }

  Future<Uint8List> downloadDocument(int documentId) async {
    if (token == null) throw Exception('Please log in first.');
    final response = await http.get(
      Uri.parse('$baseUrl/documents/$documentId/download'),
      headers: {
        'Accept': 'application/octet-stream, application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) return response.bodyBytes;

    String message = 'Document download failed.';
    try {
      message = jsonDecode(response.body)['message'] ?? message;
    } catch (_) {
      // Keep the safe fallback for non-JSON server errors.
    }
    throw Exception(message);
  }

  Future<http.Response> _authorizedJsonRequest(
    String method,
    String path,
    Map<String, dynamic> body,
  ) async {
    if (token == null) throw Exception('Please log in first.');
    final uri = Uri.parse('$baseUrl$path');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final encodedBody = jsonEncode(body);
    if (method == 'PATCH') {
      return http.patch(uri, headers: headers, body: encodedBody);
    }
    return http.post(uri, headers: headers, body: encodedBody);
  }

  Future<List<dynamic>> getNotifications() async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result['data'] as List<dynamic>;
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

    request.fields['required_document_id'] = requiredDocumentId.toString();

    request.files.add(
      http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final result = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return result as Map<String, dynamic>;
    }

    throw Exception(result['message'] ?? 'Document upload failed.');
  }

  Future<Map<String, dynamic>> submitApplication({
    required int applicationId,
  }) async {
    if (token == null) {
      throw Exception('Please log in first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/applications/$applicationId/submit'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result as Map<String, dynamic>;
    }

    throw Exception(result['message'] ?? 'Application submission failed.');
  }
}
