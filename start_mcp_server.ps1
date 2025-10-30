# Скрипт запуска FastMCP Demo Server
$ErrorActionPreference = "Stop"

# Устанавливаем кодировку UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Переходим в директорию скрипта
Set-Location $PSScriptRoot

Write-Host "🚀 Запуск FastMCP Demo Server..." -ForegroundColor Cyan
Write-Host ""

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
Write-Host ""

# Активируем venv и запускаем сервер
& '..\venv\Scripts\Activate.ps1'
& '..\venv\Scripts\fastmcp.exe' run demo_server.py
