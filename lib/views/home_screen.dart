import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cryptocurrency_viewmodel.dart';
import '../utils/formatters.dart';
import 'crypto_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearch = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CryptocurrencyViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              _buildSearchSection(viewModel),
              _buildConnectionStatus(viewModel),
              Expanded(
                child: _buildBody(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchSection(CryptocurrencyViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Pesquisar Criptomoedas',
              hintText: 'Ex: BTC,ETH,SOL (separadas por vírgula)',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              _currentSearch = value;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: viewModel.isLoading
                      ? null
                      : () => _performSearch(viewModel),
                  icon: const Icon(Icons.search),
                  label: const Text('Pesquisar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: viewModel.isLoading
                    ? null
                    : () => _loadDefaultCryptos(viewModel),
                icon: const Icon(Icons.refresh),
                label: const Text('Padrão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(CryptocurrencyViewModel viewModel) {
    if (!viewModel.hasInternetConnection) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        color: Colors.red.shade100,
        child: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Sem conexão com a internet',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBody(CryptocurrencyViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Carregando criptomoedas...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _performSearch(viewModel),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.cryptocurrencies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.currency_bitcoin,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma criptomoeda encontrada',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _performRefresh(viewModel),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: viewModel.cryptocurrencies.length,
        itemBuilder: (context, index) {
          final crypto = viewModel.cryptocurrencies[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade600,
                child: Text(
                  crypto.symbol.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                crypto.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(crypto.symbol),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.formatUsd(crypto.priceUsd),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              onTap: () => _navigateToDetail(crypto),
            ),
          );
        },
      ),
    );
  }

  void _performSearch(CryptocurrencyViewModel viewModel) {
    viewModel.loadCryptocurrencies(_currentSearch.trim());
  }

  void _loadDefaultCryptos(CryptocurrencyViewModel viewModel) {
    _searchController.clear();
    _currentSearch = '';
    viewModel.loadCryptocurrencies('');
  }

  Future<void> _performRefresh(CryptocurrencyViewModel viewModel) async {
    await viewModel.refreshCryptocurrencies(_currentSearch.trim());
  }

  void _navigateToDetail(crypto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CryptoDetailScreen(cryptocurrency: crypto),
      ),
    );
  }
}