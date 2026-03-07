import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Service for fetching Bitcoin-related data
class BitcoinService {
  final http.Client _client;
  
  BitcoinService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch current Bitcoin price in USD
  Future<BitcoinPrice?> fetchPrice() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.bitcoinPriceEndpoint),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BitcoinPrice.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching Bitcoin price: $e');
      return null;
    }
  }

  /// Fetch blockchain statistics
  Future<BlockchainStats?> fetchStats() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.blockchainInfoEndpoint),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BlockchainStats.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching blockchain stats: $e');
      return null;
    }
  }

  /// Fetch Bitcoin price from CoinGecko (external API)
  Future<BitcoinPrice?> fetchPriceFromCoinGecko() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${BitcoinApiConstants.coinGeckoBaseUrl}'
          '${BitcoinApiConstants.coinGeckoPriceEndpoint}',
        ),
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final btcData = data['bitcoin'];
        return BitcoinPrice(
          priceUsd: (btcData['usd'] as num?)?.toDouble() ?? 0,
          change24h: (btcData['usd_24h_change'] as num?)?.toDouble() ?? 0,
          lastUpdated: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Error fetching from CoinGecko: $e');
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Model for Bitcoin price data
class BitcoinPrice {
  final double priceUsd;
  final double change24h;
  final DateTime lastUpdated;

  BitcoinPrice({
    required this.priceUsd,
    required this.change24h,
    required this.lastUpdated,
  });

  factory BitcoinPrice.fromJson(Map<String, dynamic> json) {
    return BitcoinPrice(
      priceUsd: (json['priceUsd'] as num?)?.toDouble() ?? 0,
      change24h: (json['change24h'] as num?)?.toDouble() ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priceUsd': priceUsd,
      'change24h': change24h,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Format price with USD symbol
  String get formattedPrice => '\$${_formatNumber(priceUsd)}';

  /// Format 24h change with sign
  String get formattedChange {
    final sign = change24h >= 0 ? '+' : '';
    return '$sign${change24h.toStringAsFixed(2)}%';
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return number.toStringAsFixed(2);
  }
}

/// Model for blockchain statistics
class BlockchainStats {
  final int blockHeight;
  final int totalTransactions;
  final double hashRate;
  final int difficulty;
  final int mempoolSize;
  final DateTime lastUpdated;

  BlockchainStats({
    required this.blockHeight,
    required this.totalTransactions,
    required this.hashRate,
    required this.difficulty,
    required this.mempoolSize,
    required this.lastUpdated,
  });

  factory BlockchainStats.fromJson(Map<String, dynamic> json) {
    return BlockchainStats(
      blockHeight: json['blockHeight'] as int? ?? 0,
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      hashRate: (json['hashRate'] as num?)?.toDouble() ?? 0,
      difficulty: json['difficulty'] as int? ?? 0,
      mempoolSize: json['mempoolSize'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  /// Format hash rate in EH/s
  String get formattedHashRate {
    if (hashRate >= 1e18) {
      return '${(hashRate / 1e18).toStringAsFixed(2)} EH/s';
    } else if (hashRate >= 1e15) {
      return '${(hashRate / 1e15).toStringAsFixed(2)} PH/s';
    }
    return '${hashRate.toStringAsFixed(0)} H/s';
  }
}
