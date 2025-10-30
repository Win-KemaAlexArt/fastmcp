# Скрипт запуска FastMCP Demo Server
$ErrorActionPreference = "Stop"

# Переходим в директорию скрипта
Set-Location $PSScriptRoot

Write-Host "🚀 Запуск FastMCP Demo Server..." -ForegroundColor Cyan

# Убиваем старые процессы
Write-Host "🔪 Завершение старых процессов..." -ForegroundColor Yellow

# Убиваем процессы fastmcp по имени
$processNames = @("fastmcp", "python")
foreach ($procName in $processNames) {
    $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*demo_server.py*" -or $_.CommandLine -like "*fastmcp*"
    }
    if ($processes) {
        foreach ($proc in $processes) {
            Write-Host "  Завершение процесса: $procName (PID $($proc.Id))" -ForegroundColor Yellow
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
}

# Альтернативно - убить все python процессы с fastmcp (если выше не сработало)
Get-CimInstance Win32_Process | Where-Object { 
    $_.CommandLine -like "*fastmcp*" -or $_.CommandLine -like "*demo_server.py*" 
} | ForEach-Object {
    Write-Host "  Завершение Python процесса: PID $($_.ProcessId)" -ForegroundColor Yellow
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

# Небольшая пауза для освобождения ресурсов
Start-Sleep -Milliseconds 500
Write-Host "✅ Старые процессы завершены" -ForegroundColor Green

# Активируем venv и запускаем сервер
& '..\venv\Scripts\Activate.ps1'
fastmcp run demo_server.py
