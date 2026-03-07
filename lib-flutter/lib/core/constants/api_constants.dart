/// API-related constants for BitQuest
class ApiConstants {
  ApiConstants._();

  // Base URL Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api/v1';
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  // Bitcoin API Endpoints
  static const String bitcoinPriceEndpoint = '/api/bitcoin/price';
  static const String bitcoinStatsEndpoint = '/api/bitcoin/stats';
  static const String blockchainInfoEndpoint = '/api/bitcoin/blockchain';

  // AI Tutor Endpoints
  static const String aiTutorEndpoint = '/api/ai/tutor';
  static const String aiChatEndpoint = '/api/ai/chat';
  static const String aiExplainEndpoint = '/api/ai/explain';

  // User Endpoints
  static const String userProfileEndpoint = '/api/user/profile';
  static const String userProgressEndpoint = '/api/user/progress';
  static const String userBadgesEndpoint = '/api/user/badges';

  // Missions Endpoints
  static const String missionsEndpoint = '/api/missions';
  static const String missionDetailEndpoint = '/api/missions/{id}';
  static const String missionCompleteEndpoint = '/api/missions/{id}/complete';

  // Timeout Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache Configuration
  static const Duration priceCacheDuration = Duration(minutes: 5);
  static const Duration statsCacheDuration = Duration(minutes: 15);
  static const Duration userInfoCacheDuration = Duration(hours: 1);

  // Headers
  static const String contentTypeHeader = 'application/json';
  static const String authorizationHeader = 'Authorization';
  
  static Map<String, String> get defaultHeaders => {
    'Content-Type': contentTypeHeader,
    'Accept': contentTypeHeader,
  };

  // Error Messages
  static const String networkErrorMessage = 
    'Unable to connect to the server. Please check your internet connection.';
  static const String timeoutErrorMessage = 
    'Request timed out. Please try again.';
  static const String serverErrorMessage = 
    'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 
    'An unexpected error occurred. Please try again.';
}

/// External Bitcoin API Configuration
class BitcoinApiConstants {
  BitcoinApiConstants._();

  // CoinGecko API (free tier)
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String coinGeckoPriceEndpoint = 
    '/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true';
  
  // Blockchain.com API
  static const String blockchainBaseUrl = 'https://blockchain.info';
  static const String blockchainStatsEndpoint = '/stats?format=json';
  
  // Mempool.space API
  static const String mempoolBaseUrl = 'https://mempool.space/api';
  static const String mempoolBlocksEndpoint = '/blocks/tip/height';
  static const String mempoolFeesEndpoint = '/v1/fees/recommended';
}
