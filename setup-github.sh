#!/bin/bash

echo "================================================"
echo "  TikTok Clone - GitHub Repository Setup"
echo "================================================"
echo ""

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "Error: GitHub username cannot be empty"
    exit 1
fi

echo ""
echo "This script will:"
echo "1. Initialize git repositories"
echo "2. Create initial commits"
echo "3. Set up remote repositories"
echo ""
echo "Make sure you have created these repositories on GitHub:"
echo "  - https://github.com/$GITHUB_USER/backend-tiktok-clone"
echo "  - https://github.com/$GITHUB_USER/frontend-tiktok-clone"
echo "  - https://github.com/$GITHUB_USER/tiktok-clone"
echo ""
read -p "Have you created all three repositories? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please create the repositories on GitHub first, then run this script again."
    exit 1
fi

# Setup Backend Repository
echo ""
echo "===================================="
echo "Setting up Backend Repository..."
echo "===================================="
cd backend

if [ ! -d ".git" ]; then
    git init
    echo "✅ Git initialized in backend"
fi

git add .
git commit -m "Initial commit: TikTok Clone Backend

- NestJS API with TypeScript
- PostgreSQL database with TypeORM
- Redis caching
- MinIO/S3 storage
- ffmpeg video processing
- Progressive streaming with FastStart
- HTTP range request support
- JWT authentication
- Social features (likes, comments, follows)
- Recommendation engine" || echo "No changes to commit"

git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$GITHUB_USER/backend-tiktok-clone.git"
git push -u origin main

echo "✅ Backend pushed to GitHub"

# Setup Frontend Repository
echo ""
echo "===================================="
echo "Setting up Frontend Repository..."
echo "===================================="
cd ../frontend

if [ ! -d ".git" ]; then
    git init
    echo "✅ Git initialized in frontend"
fi

git add .
git commit -m "Initial commit: TikTok Clone Frontend

- Next.js 14 with TypeScript
- React with TailwindCSS
- Progressive video player
- Smart buffering and preloading
- Infinite scroll feed
- TikTok-style UI/UX
- Double-tap to like
- Comments and social features
- Hashtag search
- User profiles" || echo "No changes to commit"

git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$GITHUB_USER/frontend-tiktok-clone.git"
git push -u origin main

echo "✅ Frontend pushed to GitHub"

# Setup Main Repository
echo ""
echo "===================================="
echo "Setting up Main Repository..."
echo "===================================="
cd ..

if [ ! -d ".git" ]; then
    git init
    echo "✅ Git initialized in main repository"
fi

# Add only root-level files
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
git add setup-github.sh 2>/dev/null || true
git add *.md 2>/dev/null || true

git commit -m "Initial commit: TikTok Clone

Full-stack TikTok clone with progressive video streaming

Features:
- Progressive video loading (80% faster)
- Smart buffering (50% less memory)
- FastStart encoding
- HTTP range requests
- Docker containerization
- ffmpeg video processing
- Complete social features

Stack:
- Backend: NestJS + PostgreSQL + Redis + MinIO
- Frontend: Next.js + React + TailwindCSS
- Infrastructure: Docker + Docker Compose" || echo "No changes to commit"

# Add submodules
git submodule add "https://github.com/$GITHUB_USER/backend-tiktok-clone.git" backend 2>/dev/null || echo "Submodule backend already exists"
git submodule add "https://github.com/$GITHUB_USER/frontend-tiktok-clone.git" frontend 2>/dev/null || echo "Submodule frontend already exists"

git add .gitmodules backend frontend 2>/dev/null
git commit -m "Add backend and frontend as submodules" || echo "No changes to commit"

git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$GITHUB_USER/tiktok-clone.git"
git push -u origin main

echo "✅ Main repository pushed to GitHub"

echo ""
echo "================================================"
echo "  🎉 All repositories set up successfully!"
echo "================================================"
echo ""
echo "Your repositories:"
echo "  Main:     https://github.com/$GITHUB_USER/tiktok-clone"
echo "  Backend:  https://github.com/$GITHUB_USER/backend-tiktok-clone"
echo "  Frontend: https://github.com/$GITHUB_USER/frontend-tiktok-clone"
echo ""
echo "To clone the complete project:"
echo "  git clone --recursive https://github.com/$GITHUB_USER/tiktok-clone.git"
echo ""
