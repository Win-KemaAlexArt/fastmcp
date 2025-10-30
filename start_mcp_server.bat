@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"

echo Starting FastMCP Demo Server...
echo.

REM Kill old processes
echo Stopping old processes...

REM Kill processes by ports (6277 - proxy, 6274 - UI inspector)
for /f "tokens=5" %%a in ('netstat -aon ^| find ":6277" ^| find "LISTENING"') do (
    echo   Stopping process on port 6277: PID %%a
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon ^| find ":6274" ^| find "LISTENING"') do (
    echo   Stopping process on port 6274: PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

REM Kill fastmcp and mcp-inspector processes
taskkill /F /IM fastmcp.exe >nul 2>&1
taskkill /F /IM mcp-inspector.exe >nul 2>&1
taskkill /F /IM npx.exe >nul 2>&1

REM Kill Python processes with demo_server.py
for /f "tokens=2" %%a in ('tasklist /v ^| findstr "demo_server.py"') do (
    echo   Stopping Python process: PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

REM Short pause
timeout /t 1 /nobreak >nul

echo Old processes stopped
echo.

call ..\venv\Scripts\activate.bat
..\venv\Scripts\fastmcp.exe run demo_server.py
