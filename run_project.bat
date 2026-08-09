@echo off
echo ===================================================
echo 🚀 SMEC Connect Multi-Tenant SaaS - Launch Script
echo ===================================================
echo.

echo [1/2] Starting Django REST Framework Backend Server...
start "SMEC Django Backend" cmd /k "cd /d %~dp0backend && .venv\Scripts\python.exe manage.py runserver 0.0.0.0:8000"

echo [2/2] Starting Flutter App Preview...
start "SMEC Flutter App" cmd /k "cd /d %~dp0mobile && flutter run -d chrome"

echo.
echo ===================================================
echo ✅ Backend running at: http://127.0.0.1:8000/api/v1/
echo ✅ OpenAPI Swagger Docs: http://127.0.0.1:8000/api/docs/
echo ✅ Flutter App launching in Chrome preview...
echo ===================================================
pause
