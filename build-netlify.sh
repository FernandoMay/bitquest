#!/bin/bash

# BITQUEST Build Script for Netlify
# Handles Flutter installation and build

set -e # Detener si hay errores

echo "🚀 Iniciando build de BITQUEST para Netlify..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Paso 0: Verificando entorno...${NC}"

# Verificar si Flutter ya está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}📱 Flutter no encontrado. Instalando...${NC}"
    
    # Descargar Flutter
    echo "   • Descargando Flutter SDK..."
    wget -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz
    
    # Extraer Flutter
    echo "   • Extrayendo Flutter..."
    tar xf flutter.tar.xz
    
    # Agregar Flutter al PATH
    export PATH="$PATH:$PWD/flutter/bin"
    
    # Verificar instalación
    echo "   • Verificando Flutter..."
    flutter --version
    
    echo -e "${GREEN}   ✅ Flutter instalado${NC}"
else
    echo -e "${GREEN}   ✅ Flutter ya está instalado${NC}"
fi

echo -e "${YELLOW}📱 Paso 1: Construyendo Flutter Web...${NC}"

# Entrar al directorio de Flutter
cd lib-flutter

# Obtener dependencias de Flutter
echo "   • Obteniendo dependencias Flutter..."
flutter pub get

# Build de Flutter web
echo "   • Ejecutando flutter build web..."
flutter build web --web-renderer canvaskit --no-sound-null-safety

# Verificar que el build exista
if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ Error: El build de Flutter falló${NC}"
    exit 1
fi

echo -e "${GREEN}   ✅ Flutter build completado${NC}"

# Copiar al directorio public del proyecto Next.js
echo "   • Copiando archivos a public/flutter..."
mkdir -p ../public/flutter
cp -r build/web/* ../public/flutter/

# Volver al directorio raíz
cd ..

echo -e "${YELLOW}🌐 Paso 2: Construyendo Next.js...${NC}"

# Instalar dependencias de Node.js
echo "   • Instalando dependencias Node.js..."
bun install

# Build de Next.js
echo "   • Ejecutando bun run build:next..."
bun run build:next

# Verificar que el build exista
if [ ! -d ".next" ]; then
    echo -e "${RED}❌ Error: El build de Next.js falló${NC}"
    exit 1
fi

echo -e "${GREEN}   ✅ Next.js build completado${NC}"

echo -e "${YELLOW}📊 Paso 3: Verificando archivos...${NC}"

# Verificar archivos clave
FILES=(
    "public/flutter/index.html"
    "public/flutter/main.dart.js"
    "public/flutter/flutter.js"
    ".next/build-manifest.json"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "   ✅ $file"
    else
        echo -e "   ❌ $file (falta)"
    fi
done

echo -e "${GREEN}🎉 Build completado exitosamente!${NC}"
echo ""
echo -e "${YELLOW}📋 Resumen:${NC}"
echo -e "   • Flutter Web: ${GREEN}✅ Listo${NC}"
echo -e "   • Next.js: ${GREEN}✅ Listo${NC}"
echo -e "   • Integración: ${GREEN}✅ Completa${NC}"
echo ""
echo -e "${YELLOW}🌐 Estructura final:${NC}"
echo -e "   • Next.js app en .next/"
echo -e "   • Flutter app en public/flutter/"
echo -e "   • Listo para deploy en Netlify"
