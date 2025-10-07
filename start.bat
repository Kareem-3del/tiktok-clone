@echo off
echo.
echo ====================================================
echo   Starting VideoVibe Recommendation System
echo ====================================================
echo.
echo This will start all services including:
echo   - PostgreSQL Database
echo   - Redis Cache
echo   - MinIO Storage
echo   - Backend API (with ffmpeg for video processing)
echo   - Frontend Web App
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo [OK] Docker is running
echo.

REM Stop any existing containers
echo Stopping existing containers...
docker-compose down

echo.
echo Building and starting services...
echo This may take a few minutes on first run...
echo.

REM Build and start all services
docker-compose up -d --build

REM Wait for services
echo.
echo Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check service status
echo.
echo Service Status:
docker-compose ps

echo.
echo ====================================================
echo   Setup Complete!
echo ====================================================
echo.
echo Access your application at:
echo   Frontend:     http://localhost:3000
echo   Backend API:  http://localhost:3001/api/v1
echo   MinIO Admin:  http://localhost:9001
echo                 (user: minioadmin, pass: minioadmin)
echo.
echo View logs with:        docker-compose logs -f
echo Stop all services:     docker-compose down
echo.
pause
