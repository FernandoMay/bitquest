#!/bin/bash

# BITQUEST Update Builds Script
# Actualiza Flutter web build y APK en public/

set -e # Detener si hay errores

echo "🔄 Actualizando builds de BITQUEST..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📱 Paso 1: Actualizando Flutter Web...${NC}"

# Build Flutter web
cd lib-flutter
echo "   • Construyendo Flutter web..."
flutter build web --web-renderer canvaskit

# Copiar a public/flutter
echo "   • Copiando a public/flutter..."
rm -rf ../public/flutter
cp -r build/web ../public/flutter

echo -e "${GREEN}   ✅ Flutter web actualizado${NC}"

echo -e "${YELLOW}📱 Paso 2: Actualizando APK...${NC}"

# Build APK
echo "   • Construyendo APK release..."
flutter build apk --release

# Copiar a public/apk
echo "   • Copiando a public/apk..."
mkdir -p ../public/apk
cp build/app/outputs/flutter-apk/app-release.apk ../public/apk/bitquest-latest.apk

echo -e "${GREEN}   ✅ APK actualizado${NC}"

# Volver al directorio raíz
cd ..

echo -e "${YELLOW}📊 Paso 3: Verificando archivos...${NC}"

# Verificar archivos
echo "   • Flutter web:"
if [ -d "public/flutter" ]; then
    count=$(find public/flutter -type f | wc -l)
    size=$(du -sh public/flutter | cut -f1)
    echo -e "   ✅ public/flutter/ ($count archivos, $size)"
else
    echo -e "   ❌ public/flutter/ (falta)"
fi

echo "   • APK:"
if [ -f "public/apk/bitquest-latest.apk" ]; then
    size=$(du -h public/apk/bitquest-latest.apk | cut -f1)
    echo -e "   ✅ public/apk/bitquest-latest.apk ($size)"
else
    echo -e "   ❌ public/apk/bitquest-latest.apk (falta)"
fi

echo -e "${GREEN}🎉 Builds actualizados correctamente!${NC}"
echo ""
echo -e "${YELLOW}📋 Resumen:${NC}"
echo -e "   • Flutter Web: ${GREEN}✅ Listo en /flutter${NC}"
echo -e "   • APK Android: ${GREEN}✅ Listo en /apk/bitquest-latest.apk${NC}"
echo -e "   • URLs de acceso:"
echo -e "     • Web: /play"
echo -e "     • APK: /apk/bitquest-latest.apk"
echo -e "     • Descargas: /download"
echo ""
echo -e "${YELLOW}🌐 Para deploy a Netlify:${NC}"
echo -e "   git add public/flutter public/apk"
echo -e "   git commit -m \"Update Flutter builds\""
echo -e "   git push"
