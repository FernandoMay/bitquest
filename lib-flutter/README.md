# BITQUEST - Flutter App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.2+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Bitcoin-F7931A?style=for-the-badge&logo=bitcoin" alt="Bitcoin">
</div>

## 🎮 Aprende Bitcoin Jugando

BITQUEST es una aplicación móvil educativa gamificada que enseña conceptos de Bitcoin a través de misiones, minijuegos y un tutor de IA interactivo. Diseñada especialmente para el contexto mexicano.

## ✨ Características

### 🗺️ Misiones
- **Mundo 1: Dinero** - Conceptos básicos del dinero
- **Mundo 2: Inflación** - Cómo afecta a tus ahorros (contexto MXN)
- **Mundo 3: Blockchain** - La tecnología detrás de Bitcoin
- **Mundo 4: Minería** - Cómo se crean nuevos bitcoins
- **Mundo 5: Wallets** - Almacenamiento seguro
- **Mundo 6: Lightning Network** - Pagos instantáneos

### 🎲 Mini-Juegos
1. **Build a Block** - Construye bloques válidos
2. **Mine the Hash** - Simula la minería
3. **Inflación MXN** - Visualiza la pérdida de valor
4. **Lightning Race** - Compite con pagos instantáneos

### 🤖 Satoshi Mentor (AI Tutor)
- Chat interactivo con IA especializada en Bitcoin
- Explicaciones claras en español
- Ejemplos contextualizados para México
- Quizzes para reforzar aprendizaje

### 👛 Wallet Lab
- Simulador de Lightning Network
- Envía sats instantáneos
- Aprende autocustodia

## 🏗️ Arquitectura

```
lib/
├── core/                    # Core functionality
│   ├── theme/              # Bitcoin-themed colors & styles
│   ├── constants/          # App configuration
│   ├── services/           # API clients & storage
│   └── utils/              # Extensions & helpers
│
├── features/               # Feature modules
│   ├── missions/          # Learning missions
│   ├── minigames/         # Educational games
│   ├── ai_tutor/          # Chat with Satoshi
│   ├── wallet_simulator/  # Lightning demo
│   └── profile/           # User progress & badges
│
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── repositories/      # Repository implementations
│   └── datasources/       # Local & remote data
│
└── main.dart              # App entry point
```

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK 3.2+
- Dart SDK 3.2+

### Pasos

```bash
# Clonar el repositorio
cd lib-flutter

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Compilar APK
flutter build apk
```

## 📦 Dependencias Principales

| Paquete | Uso |
|---------|-----|
| `flutter_bloc` | Estado de la aplicación |
| `flame` | Motor de juegos 2D |
| `go_router` | Navegación declarativa |
| `http` | Cliente HTTP |
| `google_fonts` | Tipografías |
| `shared_preferences` | Almacenamiento local |
| `lottie` | Animaciones |

## 🎨 Tema de Colores

```dart
// Bitcoin Brand Colors
bitcoinOrange: #F7931A
darkBlue:      #0F172A
gray:          #1E293B
lightningPurple: #9333EA
success:       #22C55E
warning:       #EAB308
```

## 🇲🇽 Contexto México

- Ejemplos de inflación con MXN
- Remesas USA → México
- Comparativas Western Union vs Lightning
- Datos de inclusión financiera (37M sin banco)

## 🎯 Sistema de Gamificación

### XP por Actividad
- Quiz completado: 50 XP
- Minijuego: 75-150 XP
- Misión completada: 200-500 XP

### Niveles
1. 🟡 Aprendiz de Satoshi (0-999 XP)
2. ⛏️ Minero de Bloques (1000-2499 XP)
3. ⚡ Nodo Lightning (2500-4999 XP)
4. 🔮 Maestro Bitcoin (5000+ XP)

### Badges
- 🎓 Primera Lección
- 🔐 Hash Master
- ⚡ Lightning Pro
- 🏆 Satoshi
- 💎 HODLer

## 🔧 APIs

### Bitcoin Price
```
GET /api/bitcoin/price
Response: { btc_mxn, btc_usd, change_24h, timestamp }
```

### AI Tutor
```
POST /api/ai/tutor
Body: { message: string }
Response: { response: string }
```

## 📱 Screenshots

| Home | Misiones | Juegos | Chat |
|------|----------|--------|------|
| 🏠 | 🗺️ | 🎮 | 💬 |

## 🏆 Evaluación Hackathon

| Criterio | Cómo lo Cumple |
|----------|----------------|
| Precisión Bitcoin | Conceptos técnicamente correctos |
| Interactividad | Minijuegos + AI Tutor |
| Utilidad México | Ejemplos MXN, remesas, inflación |
| UX/UI | Diseño moderno estilo Duolingo |
| Técnico | Flutter + APIs + AI |

## 📄 Licencia

MIT License - BITQUEST Team 2025

---

<div align="center">
  <p>Hecho con 🧡 para México</p>
  <p>⚡ Learn Bitcoin. Play the Future. ⚡</p>
</div>
