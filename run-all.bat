@echo off
title HSR Retail App - Startup Script
echo ===================================================
echo   HSR RETAIL APP STARTUP SCRIPT
echo ===================================================
echo.
echo [1/2] Starting backend on port 3000...
start "HSR Retail Backend" cmd /k "cd backend && npm install && npm start"

echo.
echo [2/2] Starting Flutter frontend for Chrome...
start "HSR Retail Frontend" cmd /k "cd frontend && flutter run -d chrome"

echo.
echo ===================================================
echo   System is starting up!
echo   - Backend terminal runs on Port 3000.
echo   - Flutter web app will launch in Google Chrome.
echo ===================================================
pause
