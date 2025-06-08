import '../models/cryptocurrency.dart';
import '../datasources/cryptocurrency_datasource.dart';

class CryptocurrencyRepository {
  final CryptocurrencyDataSource _dataSource = CryptocurrencyDataSource();

  Future<List<Cryptocurrency>> getCryptocurrencies(String symbols) async {
    try {
      final jsonData = await _dataSource.fetchCryptocurrencies(symbols);

      final data = jsonData['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Unexpected format: "data" is not a Map');
      }
      print('Conteúdo de jsonData["data"]:');
      print(data);

      final List<Cryptocurrency> cryptocurrencies = [];

      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          try {
            final crypto = Cryptocurrency.fromJson(value);
            cryptocurrencies.add(crypto);
          } catch (e) {
            print('Failed to parse cryptocurrency for $key: $e');
          }
        }
      });

      cryptocurrencies.sort((a, b) => a.symbol.compareTo(b.symbol));

      print('Criptomoedas convertidas:');
      cryptocurrencies.forEach((c) => print('${c.name} (${c.symbol}) - \$${c.priceUsd}'));

      return cryptocurrencies;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
