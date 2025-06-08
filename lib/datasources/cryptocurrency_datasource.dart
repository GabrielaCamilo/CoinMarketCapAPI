import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class CryptocurrencyDataSource {
  Future<Map<String, dynamic>> fetchCryptocurrencies(String symbols) async {
    try {
      final url =
          Uri.parse('${AppConstants.baseUrl}?symbol=$symbols&convert=USD');

      print('URL: $url'); // Debug
      print('Headers: ${AppConstants.headers}');
      print('Symbols: $symbols'); 

      final response = await http.get(
        url,
        headers: AppConstants.headers,
      );

      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception(
            'Failed to load cryptocurrencies: ${response.statusCode}');
      }
    } catch (e) {
      print('Detailed error: $e');
      throw Exception('Error fetching cryptocurrencies: $e');
    }
  }
}
