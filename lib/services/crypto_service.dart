import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class CryptoService {
  /// Top 10 cryptos by market cap (USD)
  static Future<List<Crypto>> fetchTopCryptos() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets'
        '?vs_currency=usd&order=market_cap_desc&per_page=10&page=1';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Failed to load cryptocurrencies (${res.statusCode})');
    }

    final List data = jsonDecode(res.body) as List;
    return data.map((e) => Crypto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Last 7 days price history (close prices) for a coin
  static Future<List<double>> fetchPriceHistory(String coinId) async {
    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart'
        '?vs_currency=usd&days=7';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Failed to load price history (${res.statusCode})');
    }

    final Map<String, dynamic> data =
        jsonDecode(res.body) as Map<String, dynamic>;
    final List prices = data['prices'] as List; // [ [timestamp, price], ... ]
    return prices.map<double>((row) => (row[1] as num).toDouble()).toList();
  }
}
