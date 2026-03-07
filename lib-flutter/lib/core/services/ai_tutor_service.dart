import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Service for AI Tutor functionality
class AiTutorService {
  final http.Client _client;
  
  AiTutorService({http.Client? client}) : _client = client ?? http.Client();

  /// Send a message to the AI tutor and get a response
  Future<AiTutorResponse?> sendMessage({
    required String message,
    required String userId,
    List<ChatMessage> context = const [],
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.aiTutorEndpoint),
        headers: ApiConstants.defaultHeaders,
        body: json.encode({
          'message': message,
          'userId': userId,
          'context': context.map((m) => m.toJson()).toList(),
        }),
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AiTutorResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error sending message to AI tutor: $e');
      return null;
    }
  }

  /// Get an explanation for a specific Bitcoin concept
  Future<String?> explainConcept({
    required String concept,
    required String level,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.aiExplainEndpoint),
        headers: ApiConstants.defaultHeaders,
        body: json.encode({
          'concept': concept,
          'level': level,
        }),
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['explanation'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting concept explanation: $e');
      return null;
    }
  }

  /// Stream a response from the AI tutor (for real-time typing effect)
  Stream<String> streamMessage({
    required String message,
    required String userId,
  }) async* {
    try {
      final request = http.Request(
        'POST',
        Uri.parse('${ApiConstants.aiTutorEndpoint}/stream'),
      );
      
      request.headers.addAll(ApiConstants.defaultHeaders);
      request.body = json.encode({
        'message': message,
        'userId': userId,
      });

      final response = await _client.send(request);

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data.isNotEmpty) {
              yield data;
            }
          }
        }
      }
    } catch (e) {
      print('Error streaming message: $e');
      yield 'Error: Unable to get response. Please try again.';
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Model for chat messages
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? concept;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.concept,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? true,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      concept: json['concept'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'concept': concept,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? concept,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      concept: concept ?? this.concept,
    );
  }
}

/// Model for AI tutor responses
class AiTutorResponse {
  final String id;
  final String content;
  final List<String> suggestions;
  final String? relatedConcept;
  final List<String> relatedMissions;

  AiTutorResponse({
    required this.id,
    required this.content,
    this.suggestions = const [],
    this.relatedConcept,
    this.relatedMissions = const [],
  });

  factory AiTutorResponse.fromJson(Map<String, dynamic> json) {
    return AiTutorResponse(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      suggestions: (json['suggestions'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
      relatedConcept: json['relatedConcept'] as String?,
      relatedMissions: (json['relatedMissions'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }
}

/// Predefined prompts for common Bitcoin questions
class AiTutorPrompts {
  AiTutorPrompts._();

  static const String welcomeMessage = '''
Welcome to BitQuest! I'm your AI Bitcoin tutor. 

I'm here to help you learn about Bitcoin in a fun and interactive way. You can ask me anything about:

• What is Bitcoin and how does it work?
• How does mining work?
• What are wallets and private keys?
• How does the Lightning Network work?
• And much more!

What would you like to learn about today?
''';

  static const List<String> suggestedQuestions = [
    'What is Bitcoin?',
    'How does mining work?',
    'What is a private key?',
    'Explain the Lightning Network',
    'How are transactions verified?',
  ];

  static const Map<String, String> quickExplanations = {
    'bitcoin': 'Bitcoin is a decentralized digital currency that operates without a central authority.',
    'mining': 'Mining is the process of validating transactions and adding them to the blockchain.',
    'wallet': 'A Bitcoin wallet stores your private keys and allows you to send and receive Bitcoin.',
    'lightning': 'The Lightning Network is a second-layer solution for faster, cheaper Bitcoin transactions.',
    'blockchain': 'A blockchain is a distributed ledger that records all Bitcoin transactions.',
    'hash': 'A hash is a fixed-size string generated from data, used in Bitcoin for security.',
    'private_key': 'A private key is a secret number that allows you to spend your Bitcoin.',
    'satoshis': 'Satoshis are the smallest unit of Bitcoin (100 million satoshis = 1 BTC).',
  };
}
