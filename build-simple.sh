#!/bin/bash

# BITQUEST Simple Build Script
# Solo construye Next.js (Flutter ya está en public/flutter)

set -e # Detener si hay errores

echo "🚀 Build simple de BITQUEST (Next.js only)..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📋 Verificando Flutter build...${NC}"

# Verificar que Flutter ya esté construido
if [ ! -d "public/flutter" ]; then
    echo -e "${RED}❌ Error: No se encuentra public/flutter"
    echo -e "${YELLOW}   Ejecuta primero: cd lib-flutter && flutter build web && cp -r build/web ../public/flutter${NC}"
    exit 1
fi

# Verificar archivos clave de Flutter
FLUTTER_FILES=(
    "public/flutter/index.html"
    "public/flutter/main.dart.js"
    "public/flutter/flutter.js"
)

for file in "${FLUTTER_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Error: Falta $file${NC}"
        echo -e "${YELLOW}   Reconstruye Flutter: cd lib-flutter && flutter build web && cp -r build/web ../public/flutter${NC}"
        exit 1
    fi
done

echo -e "${GREEN}   ✅ Flutter build encontrado${NC}"

echo -e "${YELLOW}🌐 Construyendo Next.js...${NC}"

# Instalar dependencias
bun install

# Build de Next.js
bun run build:next

# Verificar build
if [ ! -d ".next" ]; then
    echo -e "${RED}❌ Error: El build de Next.js falló${NC}"
    exit 1
fi

echo -e "${GREEN}   ✅ Next.js build completado${NC}"

echo -e "${GREEN}🎉 Build listo para Netlify!${NC}"
echo ""
echo -e "${YELLOW}📋 Estructura:${NC}"
echo -e "   • Flutter: public/flutter/ (estático)"
echo -e "   • Next.js: .next/ (build)"
echo -e "   • Deploy: netlify deploy --prod"
