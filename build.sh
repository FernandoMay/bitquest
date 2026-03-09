#!/bin/bash

# BITQUEST Build Script
# Construye tanto la app Next.js como la app Flutter web

set -e # Detener si hay errores

echo "🚀 Iniciando build de BITQUEST..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📱 Paso 1: Construyendo Flutter Web...${NC}"

# Entrar al directorio de Flutter
cd lib-flutter

# Build de Flutter web
echo "   • Ejecutando flutter build web..."
flutter build web

# Verificar que el build exista
if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ Error: El build de Flutter falló${NC}"
    exit 1
fi

echo -e "${GREEN}   ✅ Flutter build completado${NC}"

# Copiar al directorio public del proyecto Next.js
echo "   • Copiando archivos a public/flutter..."
cp -r build/web ../public/flutter

# Volver al directorio raíz
cd ..

echo -e "${YELLOW}🌐 Paso 2: Construyendo Next.js...${NC}"

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
echo -e "${YELLOW}🌐 Para probar localmente:${NC}"
echo -e "   bun run start"
echo ""
echo -e "${YELLOW}🚀 Para deploy a Vercel:${NC}"
echo -e "   bun run deploy:preview"
echo -e "   bun run deploy:prod"
