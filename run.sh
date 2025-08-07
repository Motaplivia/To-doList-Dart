#!/bin/bash

echo "🚀 Lista de Tarefas - Dart"
echo "=========================="

dart pub get
dart compile js lib/main.dart -o web/main.dart.js

echo "✅ Compilado com sucesso!"
echo "🌐 Iniciando servidor..."
echo "   Acesse: http://localhost:8080"
echo ""
echo "💡 Pressione Ctrl+C para parar"

python3 -m http.server 8080 --directory web 