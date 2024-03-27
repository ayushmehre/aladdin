import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:investing_tool/time_series_model.dart';

import 'crypolist/model.dart';

class API {
  static String apiKey = 'd3632ed893314e2293c80c1d8bfbaa99';

  Future<StockData?> fetchTimeSeriesFor(
      {String symbol = 'BTC/INR',
      int outputSize = 90,
      String interval = '1day'}) async {
    print('Fetching time series data for $symbol...');
    var uri =
        'https://api.twelvedata.com/time_series?symbol=$symbol&interval=$interval&apikey=$apiKey&outputsize=$outputSize';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return StockData.fromJson(decodedData);
    } else {
      print('Failed to load time series data for $symbol');
      return null;
    }
  }

  Future<List<CryptoPair>> fetchCryptoList() async {
    print('Fetching crypto list...');
    var uri =
        'https://api.twelvedata.com/cryptocurrencies?source=docs&apikey=$apiKey';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      List<CryptoPair> cryptoList = [];
      for (var cryptoData in decodedData['data']) {
        var cryptoPair = CryptoPair.fromJson(cryptoData);
        if (cryptoPair.currencyQuote == 'US Dollar') {
          cryptoList.add(cryptoPair);
        }
      }
      return cryptoList;
    } else {
      print('Failed to load crypto list');
      return [];
    }
  }

  Future<String> fetchLogo(String symbol) async {
    print('Fetching Logo for $symbol...');
    var uri = 'https://api.twelvedata.com/logo?symbol=$symbol&apikey=$apiKey';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['logo_base'];
    } else {
      print('Failed to load logo for $symbol');
      return '';
    }
  }

  Future<dynamic> fetchSummary(String symbol) async {
    var uri =
        'https://api.twelvedata.com/statistics?symbol=$symbol&apikey=$apiKey';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData;
    } else {
      print('Failed to load summary');
      return '';
    }
  }
}
