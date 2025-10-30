# Скрипт запуска FastMCP Demo Server с Inspector
$ErrorActionPreference = "Stop"

# Переходим в директорию скрипта
Set-Location $PSScriptRoot

Write-Host "🔍 Запуск FastMCP Demo Server с Inspector..." -ForegroundColor Cyan

# Убиваем старые процессы
Write-Host "🔪 Завершение старых процессов..." -ForegroundColor Yellow

# Убиваем процессы на портах MCP Inspector (6277 - proxy, 6274 - UI)
$ports = @(6277, 6274)
foreach ($port in $ports) {
    $connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connections) {
        foreach ($conn in $connections) {
            $processId = $conn.OwningProcess
            Write-Host "  Завершение процесса на порту ${port}: PID $processId" -ForegroundColor Yellow
            Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
        }
    }
}

# Убиваем процессы fastmcp и mcp-inspector по имени
$processNames = @("fastmcp", "mcp-inspector", "npx")
foreach ($procName in $processNames) {
    $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($proc in $processes) {
            Write-Host "  Завершение процесса: $procName (PID $($proc.Id))" -ForegroundColor Yellow
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
}

# Небольшая пауза для освобождения портов
Start-Sleep -Milliseconds 500
Write-Host "✅ Старые процессы завершены" -ForegroundColor Green

# Активируем venv и запускаем dev режим
& '..\venv\Scripts\Activate.ps1'
fastmcp dev demo_server.py
