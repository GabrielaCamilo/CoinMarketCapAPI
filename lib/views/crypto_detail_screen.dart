import 'package:flutter/material.dart';
import '../models/cryptocurrency.dart';
import '../utils/formatters.dart';

class CryptoDetailScreen extends StatelessWidget {
  final Cryptocurrency cryptocurrency;

  const CryptoDetailScreen({
    Key? key,
    required this.cryptocurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cryptocurrency.name),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  'Nome:',
                  cryptocurrency.name,
                  Icons.currency_bitcoin,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Símbolo:',
                  cryptocurrency.symbol,
                  Icons.tag,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Data de Adição:',
                  CurrencyFormatter.formatDate(cryptocurrency.dateAdded),
                  Icons.calendar_today,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Preço USD:',
                  CurrencyFormatter.formatUsd(cryptocurrency.priceUsd),
                  Icons.attach_money,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}