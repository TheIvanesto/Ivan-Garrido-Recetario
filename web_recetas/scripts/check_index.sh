#!/usr/bin/env sh
# Comprueba que index.html existe en el directorio actual
if [ -f "index.html" ]; then
  echo "index.html encontrado"
  exit 0
else
  echo "ERROR: index.html no encontrado"
  exit 1
fi