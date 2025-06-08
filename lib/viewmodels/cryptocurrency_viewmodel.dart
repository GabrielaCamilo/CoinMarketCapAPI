import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/cryptocurrency.dart';
import '../repositories/cryptocurrency_repository.dart';
import '../utils/constants.dart';

class CryptocurrencyViewModel extends ChangeNotifier {
  final CryptocurrencyRepository _repository = CryptocurrencyRepository();
  
  List<Cryptocurrency> _cryptocurrencies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _hasInternetConnection = true;

  List<Cryptocurrency> get cryptocurrencies => _cryptocurrencies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasInternetConnection => _hasInternetConnection;

  CryptocurrencyViewModel() {
    _checkConnectivity();
    _loadDefaultCryptocurrencies();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _hasInternetConnection = connectivityResult != ConnectivityResult.none;
    notifyListeners();
  }

  Future<void> loadCryptocurrencies(String symbols) async {
    if (!_hasInternetConnection) {
      _errorMessage = 'Sem conexão com a internet';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final cleanSymbols = symbols.isNotEmpty ? symbols : AppConstants.defaultSymbols;
      _cryptocurrencies = await _repository.getCryptocurrencies(cleanSymbols);
    } catch (e) {
      _errorMessage = 'Erro ao carregar criptomoedas: $e';
      _cryptocurrencies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDefaultCryptocurrencies() async {
    await loadCryptocurrencies('');
  }

  Future<void> refreshCryptocurrencies(String symbols) async {
    await _checkConnectivity();
    await loadCryptocurrencies(symbols);
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}