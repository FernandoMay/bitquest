#!/bin/bash

# BITQUEST Simple Build Script
# Solo construye Next.js (Flutter ya está en public/flutter)

set -e # Detener si hay errores

echo "🚀 Build simple de BITQUEST (Next.js only)..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Paso 0: Verificando entorno...${NC}"
echo "   • Node version: $(node --version)"
echo "   • Bun version: $(bun --version)"

echo -e "${YELLOW}📋 Verificando Flutter build...${NC}"

# Verificar que Flutter ya esté construido
if [ ! -d "public/flutter" ]; then
    echo -e "${RED}❌ Error: No se encuentra public/flutter${NC}"
    echo -e "${YELLOW}   Ejecuta primero: cd lib-flutter && flutter build web && cp -r build/web ../public/flutter${NC}"
    exit 1
fi

# Verificar archivos clave de Flutter
FLUTTER_FILES=(
    "public/flutter/index.html"
    "public/flutter/main.dart.js"
    "public/flutter/flutter.js"
    "public/flutter/flutter_bootstrap.js"
    "public/flutter/canvaskit/"
)

echo "   • Verificando archivos Flutter:"
for file in "${FLUTTER_FILES[@]}"; do
    if [ -e "$file" ]; then
        if [ -d "$file" ]; then
            echo -e "   ✅ $file (directorio)"
        else
            size=$(du -h "$file" | cut -f1)
            echo -e "   ✅ $file ($size)"
        fi
    else
        echo -e "   ❌ $file (falta)"
        echo -e "${RED}   Error: Falta el archivo $file${NC}"
        echo -e "${YELLOW}   Reconstruye Flutter: cd lib-flutter && flutter build web && cp -r build/web ../public/flutter${NC}"
        exit 1
    fi
done

echo -e "${GREEN}   ✅ Flutter build verificado${NC}"

echo -e "${YELLOW}🌐 Paso 1: Instalando dependencias Node.js...${NC}"
bun install

echo -e "${YELLOW}🌐 Paso 2: Construyendo Next.js...${NC}"

# Build de Next.js
bun run build:next

# Verificar build
if [ ! -d ".next" ]; then
    echo -e "${RED}❌ Error: El build de Next.js falló${NC}"
    exit 1
fi

echo -e "${GREEN}   ✅ Next.js build completado${NC}"

echo -e "${YELLOW}📊 Paso 3: Verificando estructura final...${NC}"

# Verificar estructura final
FINAL_DIRS=(
    ".next/"
    "public/flutter/"
    "public/flutter/assets/"
    "public/flutter/canvaskit/"
)

for dir in "${FINAL_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -type f | wc -l)
        echo -e "   ✅ $dir ($count archivos)"
    else
        echo -e "   ❌ $dir (falta)"
    fi
done

echo -e "${GREEN}🎉 Build listo para Netlify!${NC}"
echo ""
echo -e "${YELLOW}📋 Estructura final:${NC}"
echo -e "   • Flutter: public/flutter/ (estático)"
echo -e "   • Next.js: .next/ (build)"
echo -e "   • Total: $(find public/flutter .next -type f | wc -l) archivos"
echo ""
echo -e "${YELLOW}🌐 URLs disponibles:${NC}"
echo -e "   • Landing: /"
echo -e "   • Juego: /play"
echo -e "   • Flutter: /flutter/"
echo -e "   • Descargas: /download"
