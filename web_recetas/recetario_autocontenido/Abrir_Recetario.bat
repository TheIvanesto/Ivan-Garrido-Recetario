@echo off
REM Abre el recetario autocontenido en el navegador por defecto
pushd %~dp0
start "" "%~dp0recetario_chrome.html"
popd
exit /b 0
