import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class CryptocurrencyDataSource {
  Future<Map<String, dynamic>> fetchCryptocurrencies(String symbols) async {
    try {
      final url =
          Uri.parse('${AppConstants.baseUrl}?symbol=$symbols&convert=USD');

      final response = await http.get(
        url,
        headers: AppConstants.headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception(
            'Failed to load cryptocurrencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cryptocurrencies: $e');
    }
  }
}
