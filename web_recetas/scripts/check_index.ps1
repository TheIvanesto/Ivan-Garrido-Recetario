# Comprueba que index.html existe en la carpeta actual
$path = Join-Path -Path (Get-Location) -ChildPath 'index.html'
if (Test-Path $path) {
    Write-Host "index.html encontrado: $path"
    exit 0
} else {
    Write-Host "ERROR: index.html no encontrado en $path" -ForegroundColor Red
    exit 1
}