import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
class ApiService {
  // ── Configuration ──────────────────────────────────────────
  // For Android emulator, use 10.0.2.2 to reach host's localhost.
  // For a physical device on Wi-Fi, replace with your PC's local IP.
  // Example: 'http://192.168.1.100:3000'
  static const String _baseUrl = 'https://sushrut.onrender.com';

  /// Sends the medical report and/or file to the backend and returns the AI analysis.
  ///
  /// Throws an [Exception] with a user-friendly message on failure.
  Future<String> analyzeReport({String? reportText, PlatformFile? file}) async {
    final uri = Uri.parse('$_baseUrl/api/analyze');

    try {
      final request = http.MultipartRequest('POST', uri);

      if (reportText != null && reportText.isNotEmpty) {
        request.fields['report'] = reportText;
      }

      if (file != null) {
        if (file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ));
        } else if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path!,
            filename: file.name,
          ));
        }
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamedResponse);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        if (body.containsKey('result')) {
          return body['result'] as String;
        }
        throw Exception('Unexpected response from server.');
      }

      // Server returned an error
      final errorMsg = body['error'] as String? ?? 'Unknown error occurred.';
      throw Exception(errorMsg);
    } on TimeoutException {
      throw Exception(
        'Request timed out. Please check your connection and try again.',
      );
    } on http.ClientException {
      throw Exception(
        'Could not connect to the server. Make sure the backend is running.',
      );
    } on FormatException {
      throw Exception('Received an invalid response from the server.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
