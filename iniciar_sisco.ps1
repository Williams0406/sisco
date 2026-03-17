# Script para iniciar SISCO en modo desarrollo

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   Iniciando SISCO..." -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# 1. Iniciar backend Django en segundo plano
Write-Host "`n[1/2] Iniciando backend Django..." -ForegroundColor Yellow
$backend = Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-Command",
  "cd 'C:\Users\willi\Desktop\SISCO\backend'; ..\venv\Scripts\Activate.ps1; python manage.py runserver"
) -PassThru

Write-Host "      Backend iniciado (PID: $($backend.Id))" -ForegroundColor Green

# Esperar que Django levante
Start-Sleep -Seconds 3

# 2. Iniciar frontend React + Tauri
Write-Host "`n[2/2] Iniciando frontend React + Tauri..." -ForegroundColor Yellow
Set-Location "C:\Users\willi\Desktop\SISCO\frontend"
npm run tauri dev