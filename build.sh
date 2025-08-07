#!/bin/bash

echo "========================================"
echo "   Build da Aplicacao To-Do List"
echo "========================================"

echo ""
echo "[1/3] Instalando dependencias..."
dart pub get
if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao instalar dependencias"
    exit 1
fi

echo ""
echo "[2/3] Compilando Dart para JavaScript..."
dart compile js lib/main.dart -o web/main.dart.js
if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao compilar"
    exit 1
fi

echo ""
echo "[3/3] Iniciando servidor local..."
echo "Aplicacao disponivel em: http://localhost:8080"
echo "Pressione Ctrl+C para parar o servidor"
echo ""
python3 -m http.server 8080 --directory web
