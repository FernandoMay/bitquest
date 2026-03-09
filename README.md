# 🚀 BITQUEST - Aprende Bitcoin Jugando

<div align="center">
  <img src="https://img.shields.io/badge/Next.js-16-black?style=for-the-badge&logo=next.js" alt="Next.js">
  <img src="https://img.shields.io/badge/TypeScript-5-3178C6?style=for-the-badge&logo=typescript" alt="TypeScript">
  <img src="https://img.shields.io/badge/Tailwind-4-06B6D4?style=for-the-badge&logo=tailwindcss" alt="Tailwind">
  <img src="https://img.shields.io/badge/Bitcoin-F7931A?style=for-the-badge&logo=bitcoin" alt="Bitcoin">
  <img src="https://img.shields.io/badge/Prisma-6-2D3748?style=for-the-badge&logo=prisma" alt="Prisma">
</div>

## 🎮 Educación Financiera Gamificada

BITQUEST es una plataforma educativa revolucionaria que enseña conceptos de Bitcoin y finanzas descentralizadas a través de experiencias gamificadas. Diseñada específicamente para el contexto mexicano con ejemplos reales, casos de uso prácticos y tecnología de IA.

### 🌟 ¿Qué hace a BITQUEST único?

- **🇲🇽 Contexto Mexicano Real**: Ejemplos de inflación MXN, remesas, y casos de uso locales
- **🤖 AI Tutor Interactivo**: Chat con Satoshi Mentor disponible 24/7
- **🎮 Gamificación Avanzada**: Misiones, niveles, badges y sistema de XP
- **📱 Multiplataforma**: Web, Android (Flutter), y próximamente iOS
- **⚡ Lightning Network**: Simulador real de pagos instantáneos
- **📊 Datos en Tiempo Real**: Precios BTC/MXN y estadísticas económicas

## ✨ Stack Tecnológico

### 🎯 Core Framework
- **⚡ Next.js 16** - React framework con App Router para rendimiento óptimo
- **📘 TypeScript 5** - Tipado estricto para desarrollo seguro
- **🎨 Tailwind CSS 4** - Diseño utility-first con tema Bitcoin personalizado

### 🧩 UI & Experiencia de Usuario
- **🧩 shadcn/ui** - Componentes accesibles construidos sobre Radix UI
- **🎯 Lucide React** - Iconos consistentes y beautiful
- **🌈 Framer Motion** - Animaciones fluidas y micro-interacciones
- **🎨 Next Themes** - Modo oscuro/claro perfecto

### 🔄 Estado & Datos
- **🐻 Zustand** - State management simple y escalable
- **🔄 TanStack Query** - Sincronización de datos potente
- **🗄️ Prisma** - ORM TypeScript-next gen
- **🔐 NextAuth.js** - Autenticación completa y segura

### 🤖 Inteligencia Artificial
- **🧠 z-ai-web-dev-sdk** - Integración con Z.ai para desarrollo asistido
- **📝 React Markdown** - Renderizado de contenido educativo
- **� React Syntax Highlighter** - Resaltado de código técnico

### 📊 Visualización & Interacción
- **📊 Recharts** - Visualizaciones de datos económicos
- **🖱️ DND Kit** - Drag & drop moderno
- **� TanStack Table** - Tablas potentes con sorting/filtering
- **🖼️ Sharp** - Procesamiento de imágenes optimizado

### 🌍 Internacionalización
- **🌍 Next Intl** - Soporte multiidioma (Español prioritario)
- **📅 Date-fns** - Utilidades de fechas localizadas
- **🪝 ReactUse** - Hooks esenciales para patrones modernos

## 🏗️ Arquitectura del Proyecto

```
bitquest/
├── 📁 src/                           # Código fuente principal
│   ├── 📁 app/                       # Next.js App Router
│   │   ├── 📄 page.tsx              # Landing page principal
│   │   ├── 📁 (auth)/               # Rutas de autenticación
│   │   ├── 📁 dashboard/            # Panel de usuario
│   │   ├── 📁 learn/                # Contenido educativo
│   │   ├── 📁 play/                 # Minijuegos web
│   │   └── 📁 api/                  # API Routes
│   │       ├── 📁 bitcoin/          # APIs de Bitcoin
│   │       └── 📁 ai/               # APIs del tutor
│   │
│   ├── 📁 components/                # Componentes React
│   │   ├── 📁 ui/                   # shadcn/ui base
│   │   ├── 📄 bitcoin-price.tsx     # Widget precio BTC
│   │   ├── 📄 mission-card.tsx      # Tarjetas de misiones
│   │   ├── 📄 progress-tracker.tsx  # Seguimiento de progreso
│   │   └── � ai-chat.tsx           # Interfaz chat AI
│   │
│   ├── 📁 lib/                      # Utilidades y configuración
│   │   ├── 📄 prisma.ts             # Configuración DB
│   │   ├── 📄 auth.ts               # Configuración auth
│   │   ├── 📄 utils.ts              # Funciones helper
│   │   └── � types.ts              # Tipos TypeScript
│   │
│   ├── 📁 hooks/                    # Custom React hooks
│   │   ├── 📄 use-bitcoin-price.ts  # Precio BTC real-time
│   │   ├── 📄 use-user-progress.ts  # Progreso del usuario
│   │   └── 📄 use-ai-tutor.ts      # Interacción con AI
│   │
│   └── � styles/                   # Estilos globales
│       ├── 📄 globals.css           # Estilos base
│       └── 📄 bitcoin-theme.css     # Tema personalizado
│
├── 📁 lib-flutter/                   # App móvil Flutter
│   ├── 📁 lib/                      # Código fuente Flutter
│   └── � pubspec.yaml              # Dependencias Flutter
│
├── 📁 mini-services/                 # Microservicios
│   ├── 📄 docker-compose.yml         # Orquestación
│   └── 📁 services/                 # Servicios individuales
│
├── � prisma/                       # Schema de base de datos
│   ├── 📄 schema.prisma             # Modelo de datos
│   └── 📁 migrations/               # Migraciones DB
│
├── 📁 public/                       # Assets estáticos
│   ├── 📁 images/                   # Imágenes y icons
│   ├── 📁 animations/               # Lottie animations
│   └── 📄 favicon.ico               # Favicon
│
├── 📄 package.json                 # Dependencias Node.js
├── 📄 tailwind.config.ts           # Configuración Tailwind
├── 📄 next.config.ts               # Configuración Next.js
└── 📄 README.md                    # Este archivo
```

## 🚀 Quick Start

### Prerrequisitos
- **Node.js 18+** o **Bun** runtime
- **PostgreSQL** o **MySQL** para base de datos
- **Redis** para caché (opcional)

### Instalación

```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd bitquest

# 2. Instalar dependencias
bun install

# 3. Configurar variables de entorno
cp .env.example .env.local
# Editar .env.local con tus credenciales

# 4. Configurar base de datos
bun run db:push

# 5. Iniciar desarrollo
bun run dev

# 6. Acceder a la aplicación
# Web: http://localhost:3000
# Flutter: cd lib-flutter && flutter run
```

### Variables de Entorno

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/bitquest"

# NextAuth
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="http://localhost:3000"

# External APIs
BITCOIN_API_KEY="your-bitcoin-api-key"
AI_SERVICE_API_KEY="your-ai-service-key"

# App Configuration
NODE_ENV="development"
APP_URL="http://localhost:3000"
```

## 🎮 Características Principales

### 🗺️ Sistema de Misiones
- **6 Mundos Temáticos**: Desde conceptos básicos hasta Lightning Network
- **Progresión Adaptativa**: Dificultad que se ajusta al nivel del usuario
- **Contexto MXN**: Ejemplos reales de economía mexicana

### 🤖 Satoshi Mentor (AI Tutor)
```typescript
interface AIMentor {
  chat: (message: string) => Promise<AIResponse>;
  explain: (concept: string, level: 'beginner' | 'advanced') => Promise<Explanation>;
  quiz: (topic: string) => Promise<QuizQuestion>;
}
```

### � Dashboard de Usuario
- **Progreso en Tiempo Real**: XP, niveles, badges
- **Análisis de Aprendizaje**: Estadísticas personales
- **Metas Personalizadas**: Objetivos adaptados al usuario

### ⚡ Lightning Simulator
- **Transacciones Simuladas**: Envío/recepción de sats
- **Comparación de Costos**: Traditional vs Lightning
- **Casos de Uso MX**: Remesas USA → México

### 📱 Integración Multiplataforma
- **Sincronización**: Progreso entre web y móvil
- **Offline Mode**: Contenido accesible sin conexión
- **PWA Support**: Instalable como app nativa

## 🎨 Sistema de Diseño

### Tema Bitcoin
```css
:root {
  /* Brand Colors */
  --bitcoin-orange: #F7931A;
  --dark-bg: #0D0D1A;
  --card-bg: #1A1A2E;
  --lightning-purple: #9333EA;
  
  /* Semantic Colors */
  --success: #22C55E;
  --warning: #EAB308;
  --error: #EF4444;
  --info: #3B82F6;
}
```

### Componentes Clave
- **BitcoinPriceCard**: Widget precio BTC/MXN en tiempo real
- **MissionCard**: Tarjetas interactivas de misiones
- **ProgressTracker**: Visualización de progreso gamificado
- **AIChatInterface**: Chat con el tutor de IA

## 📊 APIs Endpoints

### Bitcoin Price API
```typescript
// GET /api/bitcoin/price
interface BitcoinPrice {
  btc_mxn: number;
  btc_usd: number;
  change_24h: number;
  timestamp: string;
}
```

### AI Tutor API
```typescript
// POST /api/ai/tutor
interface TutorRequest {
  message: string;
  context?: string;
  userLevel?: number;
}

interface TutorResponse {
  response: string;
  suggestedQuestions?: string[];
  hasQuiz: boolean;
  difficulty: 'easy' | 'medium' | 'hard';
}
```

### User Progress API
```typescript
// GET /api/user/progress
// POST /api/user/progress
interface UserProgress {
  userId: string;
  totalXp: number;
  currentLevel: number;
  completedMissions: string[];
  badges: string[];
  lastActive: string;
}
```

## 🗄️ Modelo de Datos

### Schema Prisma (Resumen)
```prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String
  level     Int      @default(1)
  totalXp   Int      @default(0)
  progress  MissionProgress[]
  badges    Badge[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Mission {
  id          String @id @default(cuid())
  title       String
  description String
  world       String
  xpReward    Int
  order       Int
  unlocked    Boolean @default(false)
  progress    MissionProgress[]
}

model MissionProgress {
  id        String @id @default(cuid())
  userId    String
  missionId String
  completed Boolean @default(false)
  xp        Int     @default(0)
  user      User    @relation(fields: [userId], references: [id])
  mission   Mission @relation(fields: [missionId], references: [id])
}
```

## 🚀 Despliegue

### Producción (Vercel)
```bash
# Build optimizado
bun run build

# Deploy a Vercel
vercel --prod

# Variables de entorno en Vercel
# Configurar en dashboard de Vercel
```

### Docker
```bash
# Construir imagen
docker build -t bitquest .

# Ejecutar con Docker Compose
docker-compose up -d
```

### Base de Datos
```bash
# Producción
bun run db:migrate

# Reset (desarrollo)
bun run db:reset
```

## 🧪 Testing

### Unit Tests
```bash
# Tests unitarios
bun test

# Con cobertura
bun test --coverage
```

### E2E Tests
```bash
# Tests end-to-end
bun run test:e2e

# Playwright
bun run test:playwright
```

## 📈 Analytics & Monitoreo

### Métricas Implementadas
- **User Engagement**: Tiempo de sesión, misiones completadas
- **Learning Progress**: Tasa de aprendizaje, dificultades
- **Technical Performance**: Core Web Vitals, render time
- **Business Metrics**: Conversión, retención, LTV

### Tools
- **Vercel Analytics**: Performance y user metrics
- **PostHog**: Event tracking y funnels
- **Sentry**: Error tracking y performance

## 🤝 Contribución

### Flujo de Trabajo
1. **Fork** el repositorio
2. **Crear branch** `feature/nueva-caracteristica`
3. **Implementar** con tests
4. **Commits** siguiendo Conventional Commits
5. **Pull Request** con descripción detallada
6. **Code Review** y aprobación

### Convenciones
- **Code Style**: ESLint + Prettier + TypeScript strict
- **Commits**: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`
- **Branches**: `feature/*`, `bugfix/*`, `hotfix/*`
- **PRs**: Tests requeridos + documentation updates

## 📄 Licencia

MIT License - BITQUEST Team 2025

## 🌟 Roadmap

### v1.1 (Próximamente)
- [ ] iOS App (Flutter)
- [ ] Advanced AI Features
- [ ] Multi-language Support
- [ ] Community Features

### v1.2 (Futuro)
- [ ] Blockchain Integration
- [ ] Real Bitcoin Transactions
- [ ] Teacher Dashboard
- [ ] School Integration

---

<div align="center">
  <p>🧡 Hecho con ❤️ para México 🇲🇽</p>
  <p>⚡ Learn Bitcoin. Play the Future. ⚡</p>
  <p>
    <strong>Web:</strong> <a href="https://bitquest.mx">bitquest.mx</a> | 
    <strong>WhatsApp:</strong> <a href="https://wa.me/525525069790">+525525069790</a> | 
    <strong>GitHub:</strong> <a href="https://github.com/FernandoMay/bitquest">bitquest</a>
  </p>
  <p>
    <a href="#top">↑ Volver arriba</a>
  </p>
</div>
