import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for communicating with the AI Tutor API
class AiTutorService {
  final http.Client _httpClient;
  final String _baseUrl;

  /// Default fallback responses when API fails
  static const List<String> _fallbackResponses = [
    '''**Explicación:**
Bitcoin es dinero digital que funciona sin bancos ni gobiernos. Utiliza una red descentralizada de computadoras para verificar transacciones.

**Ejemplo:**
Imagina enviar dinero a tu familia en otra ciudad. Con Bitcoin puedes hacerlo directamente, sin intermediarios, usando solo tu wallet. En México, esto es muy útil para remesas.

**Pregunta rápida:**
¿Sabes qué dispositivo se usa para guardar Bitcoin? 📱''',
    '''**Explicación:**
El halving es un evento que ocurre cada 4 años donde la recompensa que reciben los mineros se reduce a la mitad. Esto hace que Bitcoin sea más escaso con el tiempo.

**Ejemplo:**
Imagina que en una tienda hay 100 productos y cada día llegan menos productos nuevos. Los productos existentes se vuelven más valiosos por su escasez.

**Pregunta rápida:**
¿Cada cuántos años ocurre el halving? ⏰''',
    '''**Explicación:**
Una wallet (billetera) es una aplicación que te permite guardar, enviar y recibir Bitcoin. No guarda el Bitcoin físicamente, sino las claves que demuestran que te pertenece.

**Ejemplo:**
Una wallet es como una llave de tu casa. La llave no es la casa, pero te permite acceder a ella. Sin la llave (clave privada), no puedes acceder a tus Bitcoin.

**Pregunta rápida:**
¿Qué es más importante proteger: tu wallet o tu clave privada? 🔐''',
    '''**Explicación:**
Lightning Network es una capa secundaria sobre Bitcoin que permite transacciones instantáneas y con comisiones muy bajas. Es ideal para pagos del día a día.

**Ejemplo:**
Imagina que en lugar de hacer una transferencia bancaria cada vez que compras algo, usas una tarjeta prepago. Lightning funciona similar: haces muchas transacciones fuera de la blockchain principal y solo registras el resultado final.

**Pregunta rápida:**
¿Para qué tipo de compras sería más útil Lightning? ☕''',
    '''**Explicación:**
Sí, Bitcoin es legal en México. El Banco de México y la CNBV han establecido regulaciones para exchanges y servicios de criptomonedas. Puedes comprar, vender y poseer Bitcoin legalmente.

**Ejemplo:**
En México, exchanges como Bitso operan bajo regulación oficial. Puedes usar estos servicios con tranquilidad, aunque siempre es recomendable investigar y entender los riesgos.

**Pregunta rápida:**
¿Conoces algún exchange regulado en México? 🏦''',
  ];

  AiTutorService({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://localhost:3000';

  /// Send a message to the AI tutor and get a response
  Future<String> sendMessage(String message) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/api/ai/tutor'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final aiResponse = data['response'] as String?;
        
        if (aiResponse != null && aiResponse.isNotEmpty) {
          return aiResponse;
        }
      }

      // Return fallback if response is invalid
      return _getFallbackResponse(message);
    } catch (e) {
      // Return fallback on network error
      return _getFallbackResponse(message);
    }
  }

  /// Get a fallback response based on keywords in the message
  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Match keywords to appropriate fallback
    if (lowerMessage.contains('halving')) {
      return _fallbackResponses[1];
    } else if (lowerMessage.contains('wallet') || lowerMessage.contains('billetera')) {
      return _fallbackResponses[2];
    } else if (lowerMessage.contains('lightning')) {
      return _fallbackResponses[3];
    } else if (lowerMessage.contains('legal') || lowerMessage.contains('méxico') || lowerMessage.contains('mexico')) {
      return _fallbackResponses[4];
    }
    
    // Default fallback for Bitcoin questions
    return _fallbackResponses[0];
  }

  /// Dispose of resources
  void dispose() {
    _httpClient.close();
  }
}
