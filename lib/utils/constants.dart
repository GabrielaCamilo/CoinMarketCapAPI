class AppConstants {
  static const String apiKey = '081e3d97-5f76-4c27-82e8-dfe1a08e05d3';
  static const String baseUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';

  static const String defaultSymbols =
      'BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA,XRP,TIA,NEO,NEAR,PENDLE,RENDER,LINK,TON,XAI,SEI,IMX,ETHFI,UMA,SUPER,FET,USUAL,GALA,PAAL,AERO';

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'X-CMC_PRO_API_KEY': apiKey,
  };
}
