class Cryptocurrency {
  final String name;
  final String symbol;
  final String dateAdded;
  final double priceUsd;

  Cryptocurrency({
    required this.name,
    required this.symbol,
    required this.dateAdded,
    required this.priceUsd,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    print('Convertendo JSON para modelo: $json');
    final quote = json['quote'];
    final usdQuote = quote['USD'];

    return Cryptocurrency(
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      dateAdded: json['date_added'] ?? '',
      priceUsd: (usdQuote?['price'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Cryptocurrency{name: $name, symbol: $symbol, priceUsd: $priceUsd}';
  }
}