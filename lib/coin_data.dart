import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utilities/untracked_constants.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  CoinData({required this.currency, required this.cryptoType});
  final String currency;
  final String cryptoType;
  String baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';
  Future getCoinData() async {
    Uri fullUrl = Uri.parse('$baseUrl$cryptoType/$currency?apikey=$coinApiKey');
    http.Response response = await http.get(fullUrl);
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      return jsonDecode(data);
    } else {
      print('request failed with status ${response.statusCode}');
      print(response.body);
      Map<String, double> unknownRate = {'rate': 0.00};
      return unknownRate;
    }
  }
}
