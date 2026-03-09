# BITQUEST - Flutter App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.2+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Bitcoin-F7931A?style=for-the-badge&logo=bitcoin" alt="Bitcoin">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50?style=for-the-badge" alt="Platforms">
</div>

## 🎮 Aprende Bitcoin Jugando

BITQUEST es una aplicación móvil educativa gamificada que enseña conceptos de Bitcoin a través de misiones, minijuegos y un tutor de IA interactivo. Diseñada especialmente para el contexto mexicano con ejemplos reales y casos de uso prácticos.

## ✨ Características Principales

### 🗺️ Sistema de Misiones
- **Mundo 1: Dinero** - Conceptos básicos del dinero y su evolución
- **Mundo 2: Inflación** - Impacto en México y comparativas MXN vs BTC
- **Mundo 3: Blockchain** - Tecnología descentralizada y seguridad
- **Mundo 4: Minería** - Proof of Work y halving
- **Mundo 5: Wallets** - Autocustodia y seguridad de claves
- **Mundo 6: Lightning Network** - Pagos instantáneos y remesas

### 🎲 Mini-Juegos Educativos
1. **Build a Block** - Construye bloques válidos arrastrando elementos
2. **Mine the Hash** - Simula minería de Bitcoin con puzzles
3. **Inflación MXN** - Visualiza la pérdida de valor del peso
4. **Lightning Race** - Compite enviando pagos instantáneos

### 🤖 Satoshi Mentor (AI Tutor)
- Chat interactivo con IA especializada en Bitcoin
- Explicaciones claras y adaptadas al nivel del usuario
- Ejemplos contextualizados para la economía mexicana
- Quizzes interactivos para reforzar aprendizaje
- Disponible 24/7 para resolver dudas

### 👛 Wallet Simulator
- Simulador interactivo de Lightning Network
- Envía y recibe sats instantáneamente
- Practica autocustodia sin riesgo real
- Compara costos de remesas tradicionales vs Lightning

## 🏗️ Arquitectura Técnica

### Clean Architecture + BLoC Pattern

```
lib/
├── core/                           # Capa central
│   ├── theme/                     # Tema Bitcoin y estilos
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   ├── constants/                 # Configuración de la app
│   │   └── app_constants.dart
│   ├── services/                  # Servicios globales
│   │   ├── storage_service.dart
│   │   └── api_service.dart
│   ├── utils/                      # Extensiones y helpers
│   │   └── extensions.dart
│   └── errors/                     # Manejo de errores
│       └── failures.dart
│
├── features/                       # Módulos de características
│   ├── missions/                  # Sistema de misiones
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── mission.dart
│   │   │   │   └── player_progress.dart
│   │   │   ├── repositories/
│   │   │   │   └── mission_repository_impl.dart
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── ai_tutor/                  # Chat con IA
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chat_message.dart
│   │   │   ├── services/
│   │   │   │   └── ai_tutor_service.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── ai_tutor_bloc.dart
│   │       │   ├── ai_tutor_event.dart
│   │       │   └── ai_tutor_state.dart
│   │       ├── pages/
│   │       │   └── chat_page.dart
│   │       └── widgets/
│   │           ├── chat_input.dart
│   │           └── message_bubble.dart
│   │
│   ├── minigames/                 # Juegos educativos
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── minigames_page.dart
│   │   │   └── widgets/
│   │   │       └── minigame_card.dart
│   │   └── data/
│   │       └── models/
│   │
│   ├── wallet_simulator/          # Simulador Lightning
│   │   ├── presentation/
│   │   │   └── pages/
│   │   │       └── wallet_page.dart
│   │   └── data/
│   │
│   └── profile/                   # Perfil y progreso
│       ├── presentation/
│       │   └── pages/
│       │       └── profile_page.dart
│       └── data/
│
├── data/                          # Capa de datos global
│   ├── datasources/
│   │   └── local_data_source.dart
│   └── models/
│       └── player_model.dart
│
├── home_page.dart                 # Navegación principal
└── main.dart                      # Entry point
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- **Flutter SDK**: 3.2.0 o superior
- **Dart SDK**: 3.2.0 o superior
- **Android Studio** o **VS Code** con extensión Flutter
- **Android SDK** para desarrollo Android
- **Xcode** para desarrollo iOS (solo macOS)

### Configuración del Entorno

```bash
# 1. Verificar instalación de Flutter
flutter doctor

# 2. Clonar el repositorio
git clone <repository-url>
cd lib-flutter

# 3. Instalar dependencias
flutter pub get

# 4. Crear archivos de plataforma (si es necesario)
flutter create .

# 5. Ejecutar en modo desarrollo
flutter run

# 6. Compilar para producción
# APK para Android
flutter build apk --release

# App Bundle para Google Play
flutter build appbundle --release

# iOS (solo macOS)
flutter build ios --release
```

### Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
# API Configuration
API_BASE_URL=https://api.bitquest.mx
AI_TUTOR_API_URL=https://api.bitquest.mx/ai/tutor
BITCOIN_PRICE_API=https://api.bitquest.mx/bitcoin/price

# App Configuration
APP_ENV=development
DEBUG_MODE=true
```

## 📦 Dependencias Principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| `flutter_bloc` | ^8.1.6 | Gestión de estado con BLoC |
| `flame` | ^1.17.0 | Motor de juegos 2D |
| `go_router` | ^13.2.0 | Navegación declarativa |
| `http` | ^1.2.0 | Cliente HTTP para APIs |
| `equatable` | ^2.0.5 | Comparación de objetos |
| `shared_preferences` | ^2.2.2 | Almacenamiento local |
| `uuid` | ^4.4.0 | Generación de IDs únicos |
| `flutter_animate` | ^4.5.2 | Animaciones fluidas |
| `google_fonts` | ^6.1.0 | Tipografías personalizadas |
| `lottie` | ^3.1.0 | Animaciones vectoriales |
| `flutter_markdown` | ^0.7.7+1 | Renderizado de Markdown |
| `intl` | ^0.20.2 | Internacionalización |

## 🎨 Sistema de Diseño

### Paleta de Colores Bitcoin

```dart
class AppColors {
  // Brand Colors
  static const bitcoinOrange = Color(0xFFF7931A);
  static const darkBlue = Color(0xFF0F172A);
  static const lightningPurple = Color(0xFF9333EA);
  
  // Semantic Colors
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFEAB308);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  
  // Neutral Colors
  static const gray = Color(0xFF1E293B);
  static const grayLight = Color(0xFF334155);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFF94A3B8);
}
```

### Tipografías
- **Primary**: Inter (Google Fonts)
- **Monospace**: JetBrains Mono (para código técnico)
- **Display**: Bitcoin (personalizada para branding)

## 🇲🇽 Contexto Mexicano

### Casos de Uso Reales
- **Inflación MXN**: Comparativas históricas y proyecciones
- **Remesas**: USA → México via Lightning Network
- **Inclusión Financiera**: 37M mexicanos sin acceso a bancos
- **Adopción**: Ejemplos de empresas mexicanas aceptando Bitcoin

### Datos Locales
- Tipo de cambio BTC/MXN en tiempo real
- Estadísticas de inflación mensuales (INEGI)
- Costos de remesas tradicionales vs Lightning
- Regulaciones mexicanas sobre criptomonedas

## 🎯 Sistema de Gamificación

### Sistema de XP
```dart
class XPRewards {
  static const int quizCompleted = 50;
  static const int minigameEasy = 75;
  static const int minigameMedium = 100;
  static const int minigameHard = 150;
  static const int missionCompleted = 200;
  static const int worldCompleted = 500;
}
```

### Sistema de Niveles
1. 🟡 **Aprendiz de Satoshi** (0-999 XP)
   - Acceso a Mundos 1-2
   - Tutor básico disponible

2. ⛏️ **Minero de Bloques** (1000-2499 XP)
   - Acceso a Mundos 1-4
   - Minijuegos avanzados

3. ⚡ **Nodo Lightning** (2500-4999 XP)
   - Acceso completo a todos los mundos
   - Wallet Simulator desbloqueado

4. 🔮 **Maestro Bitcoin** (5000+ XP)
   - Contenido exclusivo
   - Badge especial

### Sistema de Badges
- 🎓 **Primera Lección** - Completar primer quiz
- 🔐 **Hash Master** - Dominar conceptos de minería
- ⚡ **Lightning Pro** - Completar simulador Lightning
- 🏆 **Satoshi** - Alcanzar nivel máximo
- 💎 **HODLer** - Mantener streak de 30 días
- 🇲🇽 **Bitcoinero MX** - Completar contenido México

## 🔧 Integración de APIs

### Bitcoin Price API
```dart
// Endpoint: GET /api/bitcoin/price
interface BitcoinPrice {
  final double btc_mxn;
  final double btc_usd;
  final double change_24h;
  final DateTime timestamp;
}
```

### AI Tutor API
```dart
// Endpoint: POST /api/ai/tutor
interface TutorRequest {
  final String message;
  final String? context;
}

interface TutorResponse {
  final String response;
  final List<String>? suggestedQuestions;
  final bool hasQuiz;
}
```

### Player Progress API
```dart
// Endpoint: GET/POST /api/player/progress
interface PlayerProgress {
  final String playerId;
  final int totalXp;
  final int currentLevel;
  final Map<String, MissionProgress> missionProgress;
  final List<String> badges;
  final DateTime lastActive;
}
```

## 📱 Plataformas Soportadas

### Android
- **Versión mínima**: Android 8.0 (API 26)
- **Arquitectura**: ARM64, x86_64
- **Tamaño**: ~45 MB
- **Permisos**: Internet, Almacenamiento

### iOS (Próximamente)
- **Versión mínima**: iOS 13.0+
- **Dispositivos**: iPhone, iPad
- **Tamaño**: ~50 MB

### Web (Experimental)
- **Navegadores**: Chrome 90+, Safari 14+, Firefox 88+
- **PWA**: Soporte completo
- **Offline**: Cache estratégico

## 🧪 Testing

### Unit Tests
```bash
# Ejecutar tests unitarios
flutter test

# Con cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Integration Tests
```bash
# Tests de integración
flutter test integration_test/
```

## 📊 Analytics y Monitoreo

### Métricas Implementadas
- **Eventos de Usuario**: Login, misiones completadas, tiempo de sesión
- **Performance**: Tiempo de carga, renderizado de UI
- **Errores**: Crash reporting, excepciones no manejadas
- **Business**: Tasa de conversión, retención de usuarios

## 🔒 Seguridad

### Medidas de Seguridad
- **Encriptación local**: Datos sensibles encriptados
- **API Segura**: HTTPS + API Keys
- **Validación de entrada**: Sanitización de datos
- **Autenticación**: JWT tokens para APIs
- **Privacy**: Cumplimiento GDPR y protección de datos

## 🚀 Despliegue

### Android (Google Play Store)
```bash
# 1. Generar keystore de firma
keytool -genkey -v -keystore bitquest-release.keystore -alias bitquest -keyalg RSA -keysize 2048 -validity 10000

# 2. Compilar release
flutter build appbundle --release --keystore bitquest-release.keystore

# 3. Subir a Google Play Console
# Archivo: build/app/outputs/bundle/release/app-release.aab
```

### Web (Vercel/Netlify)
```bash
# 1. Compilar web
flutter build web --web-renderer canvaskit

# 2. Deploy
# Subir carpeta build/web a hosting
```

## 🤝 Contribución

### Flujo de Trabajo
1. Fork del repositorio
2. Crear branch feature/nombre-característica
3. Implementar cambios con tests
4. Submit Pull Request con descripción detallada
5. Code review y aprobación

### Convenciones
- **Code Style**: dart format + flutter_lints
- **Commits**: Conventional Commits
- **Branches**: feature/*, bugfix/*, hotfix/*
- **PRs**: Requeridos tests y documentación

## 📄 Licencia

MIT License - BITQUEST Team 2025

---

<div align="center">
  <p>🧡 Hecho con amor para México 🇲🇽</p>
  <p>⚡ Learn Bitcoin. Play the Future. ⚡</p>
  <p>
    <a href="#top">↑ Volver arriba</a>
  </p>
</div>
