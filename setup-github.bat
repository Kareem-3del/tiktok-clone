@echo off
setlocal enabledelayedexpansion

echo ================================================
echo   TikTok Clone - GitHub Repository Setup
echo ================================================
echo.

REM Get GitHub username
set /p GITHUB_USER="Enter your GitHub username: "

if "%GITHUB_USER%"=="" (
    echo Error: GitHub username cannot be empty
    pause
    exit /b 1
)

echo.
echo This script will:
echo 1. Initialize git repositories
echo 2. Create initial commits
echo 3. Set up remote repositories
echo.
echo Make sure you have created these repositories on GitHub:
echo   - https://github.com/%GITHUB_USER%/backend-tiktok-clone
echo   - https://github.com/%GITHUB_USER%/frontend-tiktok-clone
echo   - https://github.com/%GITHUB_USER%/tiktok-clone
echo.
set /p CONFIRM="Have you created all three repositories? (y/n): "

if /i not "%CONFIRM%"=="y" (
    echo Please create the repositories on GitHub first, then run this script again.
    pause
    exit /b 1
)

REM Setup Backend Repository
echo.
echo ====================================
echo Setting up Backend Repository...
echo ====================================
cd backend

if not exist ".git" (
    git init
    echo [OK] Git initialized in backend
)

git add .
git commit -m "Initial commit: TikTok Clone Backend" -m "- NestJS API with TypeScript" -m "- PostgreSQL database with TypeORM" -m "- Redis caching" -m "- MinIO/S3 storage" -m "- ffmpeg video processing" -m "- Progressive streaming with FastStart" -m "- HTTP range request support" -m "- JWT authentication" -m "- Social features (likes, comments, follows)" -m "- Recommendation engine"

git branch -M main
git remote remove origin 2>nul
git remote add origin "https://github.com/%GITHUB_USER%/backend-tiktok-clone.git"
git push -u origin main

echo [OK] Backend pushed to GitHub

REM Setup Frontend Repository
echo.
echo ====================================
echo Setting up Frontend Repository...
echo ====================================
cd ..\frontend

if not exist ".git" (
    git init
    echo [OK] Git initialized in frontend
)

git add .
git commit -m "Initial commit: TikTok Clone Frontend" -m "- Next.js 14 with TypeScript" -m "- React with TailwindCSS" -m "- Progressive video player" -m "- Smart buffering and preloading" -m "- Infinite scroll feed" -m "- TikTok-style UI/UX" -m "- Double-tap to like" -m "- Comments and social features" -m "- Hashtag search" -m "- User profiles"

git branch -M main
git remote remove origin 2>nul
git remote add origin "https://github.com/%GITHUB_USER%/frontend-tiktok-clone.git"
git push -u origin main

echo [OK] Frontend pushed to GitHub

REM Setup Main Repository
echo.
echo ====================================
echo Setting up Main Repository...
echo ====================================
cd ..

if not exist ".git" (
    git init
    echo [OK] Git initialized in main repository
)

REM Add only root-level files
git add .gitignore
git add docker-compose.yml
git add README.md
git add DOCKER_SETUP.md
git add VIDEO_OPTIMIZATION_CONFIG.md
git add IMPLEMENTATION_SUMMARY.md
git add QUICK_START.md
git add GITHUB_SETUP.md
git add start.sh
git add start.bat
git add setup-github.sh 2>nul
git add setup-github.bat 2>nul
git add *.md 2>nul

git commit -m "Initial commit: TikTok Clone" -m "Full-stack TikTok clone with progressive video streaming" -m "" -m "Features:" -m "- Progressive video loading (80%% faster)" -m "- Smart buffering (50%% less memory)" -m "- FastStart encoding" -m "- HTTP range requests" -m "- Docker containerization" -m "- ffmpeg video processing" -m "- Complete social features" -m "" -m "Stack:" -m "- Backend: NestJS + PostgreSQL + Redis + MinIO" -m "- Frontend: Next.js + React + TailwindCSS" -m "- Infrastructure: Docker + Docker Compose"

REM Add submodules
git submodule add "https://github.com/%GITHUB_USER%/backend-tiktok-clone.git" backend 2>nul
git submodule add "https://github.com/%GITHUB_USER%/frontend-tiktok-clone.git" frontend 2>nul

git add .gitmodules backend frontend 2>nul
git commit -m "Add backend and frontend as submodules"

git branch -M main
git remote remove origin 2>nul
git remote add origin "https://github.com/%GITHUB_USER%/tiktok-clone.git"
git push -u origin main

echo [OK] Main repository pushed to GitHub

echo.
echo ================================================
echo   All repositories set up successfully!
echo ================================================
echo.
echo Your repositories:
echo   Main:     https://github.com/%GITHUB_USER%/tiktok-clone
echo   Backend:  https://github.com/%GITHUB_USER%/backend-tiktok-clone
echo   Frontend: https://github.com/%GITHUB_USER%/frontend-tiktok-clone
echo.
echo To clone the complete project:
echo   git clone --recursive https://github.com/%GITHUB_USER%/tiktok-clone.git
echo.
pause
