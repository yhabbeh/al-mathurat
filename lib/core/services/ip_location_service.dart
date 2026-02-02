import 'dart:convert';
import 'package:http/http.dart' as http;

class IpLocationService {
  static const String _baseUrl = 'http://ip-api.com/json';

  Future<Map<String, dynamic>> getLocation() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get IP location');
      }
    } catch (e) {
      throw Exception('Network error during IP location fetch: $e');
    }
  }
}
