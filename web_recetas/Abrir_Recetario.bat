@echo off
REM Lanzador para abrir el recetario en el navegador por defecto
pushd %~dp0
start "" "%~dp0index.html"
popd
exit /b 0
