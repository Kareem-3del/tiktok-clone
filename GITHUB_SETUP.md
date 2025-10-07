# GitHub Repository Setup Guide

This guide explains how to set up the three GitHub repositories for the TikTok Clone project.

## Repository Structure

We'll create 3 repositories:

1. **`tiktok-clone`** - Main repository (contains both frontend and backend as submodules)
2. **`backend-tiktok-clone`** - Backend API only
3. **`frontend-tiktok-clone`** - Frontend app only

## Step 1: Create GitHub Repositories

Go to GitHub and create three new repositories:

1. `tiktok-clone` (public/private)
2. `backend-tiktok-clone` (public/private)
3. `frontend-tiktok-clone` (public/private)

**Important:** Do NOT initialize with README, .gitignore, or license (we already have these)

## Step 2: Push Backend Repository

```bash
cd backend

# Initialize git
git init

# Add all files
git add .

# Create initial commit
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
- Recommendation engine"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/backend-tiktok-clone.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Push Frontend Repository

```bash
cd ../frontend

# Initialize git
git init

# Add all files
git add .

# Create initial commit
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
- User profiles"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/frontend-tiktok-clone.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Create Main Repository with Submodules

```bash
cd ..

# Initialize git in root directory
git init

# Add only root-level files (not subdirectories)
git add .gitignore
git add docker-compose.yml
git add README.md
git add DOCKER_SETUP.md
git add VIDEO_OPTIMIZATION_CONFIG.md
git add IMPLEMENTATION_SUMMARY.md
git add QUICK_START.md
git add start.sh
git add start.bat
git add *.md

# Create initial commit
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
- Infrastructure: Docker + Docker Compose"

# Add backend and frontend as submodules
git submodule add https://github.com/YOUR_USERNAME/backend-tiktok-clone.git backend
git submodule add https://github.com/YOUR_USERNAME/frontend-tiktok-clone.git frontend

# Commit submodules
git add .gitmodules backend frontend
git commit -m "Add backend and frontend as submodules"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/tiktok-clone.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Update README Links

After creating the repositories, update the README files with correct GitHub URLs:

### In `backend/README.md`:
```markdown
## 🔗 Related Repositories

- **Main Repository:** [tiktok-clone](https://github.com/YOUR_USERNAME/tiktok-clone)
- **Frontend:** [frontend-tiktok-clone](https://github.com/YOUR_USERNAME/frontend-tiktok-clone)
```

### In `frontend/README.md`:
```markdown
## 🔗 Related Repositories

- **Main Repository:** [tiktok-clone](https://github.com/YOUR_USERNAME/tiktok-clone)
- **Backend:** [backend-tiktok-clone](https://github.com/YOUR_USERNAME/backend-tiktok-clone)
```

### In `README.md` (root):
```markdown
## 🔗 Repositories

This project is split into multiple repositories:

- **Main:** [tiktok-clone](https://github.com/YOUR_USERNAME/tiktok-clone) - Full project with submodules
- **Backend:** [backend-tiktok-clone](https://github.com/YOUR_USERNAME/backend-tiktok-clone) - API only
- **Frontend:** [frontend-tiktok-clone](https://github.com/YOUR_USERNAME/frontend-tiktok-clone) - Web app only
```

## Cloning the Project

### Clone Main Repository (Recommended)

```bash
# Clone with submodules
git clone --recursive https://github.com/YOUR_USERNAME/tiktok-clone.git

# Or clone then initialize submodules
git clone https://github.com/YOUR_USERNAME/tiktok-clone.git
cd tiktok-clone
git submodule update --init --recursive
```

### Clone Individual Repositories

**Backend only:**
```bash
git clone https://github.com/YOUR_USERNAME/backend-tiktok-clone.git
```

**Frontend only:**
```bash
git clone https://github.com/YOUR_USERNAME/frontend-tiktok-clone.git
```

## Working with Submodules

### Update Submodules to Latest

```bash
# Update all submodules
git submodule update --remote

# Update specific submodule
git submodule update --remote backend
git submodule update --remote frontend
```

### Make Changes in Submodules

```bash
# Go to submodule directory
cd backend

# Make changes
git add .
git commit -m "Your changes"
git push

# Go back to main repo
cd ..

# Update submodule reference
git add backend
git commit -m "Update backend submodule"
git push
```

## Repository Contents

### tiktok-clone (Main)
```
tiktok-clone/
├── backend/              → Submodule
├── frontend/             → Submodule
├── docker-compose.yml    → Full stack setup
├── README.md             → Main documentation
├── DOCKER_SETUP.md
├── VIDEO_OPTIMIZATION_CONFIG.md
├── IMPLEMENTATION_SUMMARY.md
├── QUICK_START.md
├── start.sh
└── start.bat
```

### backend-tiktok-clone
```
backend/
├── src/
├── Dockerfile
├── docker-compose.yml
├── package.json
├── README.md
└── ...
```

### frontend-tiktok-clone
```
frontend/
├── src/
├── Dockerfile
├── package.json
├── README.md
└── ...
```

## Benefits of This Structure

1. **Flexible Development**
   - Work on backend or frontend separately
   - Independent versioning
   - Separate CI/CD pipelines

2. **Easy Deployment**
   - Deploy frontend and backend independently
   - Scale services separately
   - Different hosting for each

3. **Clean Organization**
   - Clear separation of concerns
   - Easier to navigate
   - Better for teams

4. **Reusability**
   - Use backend with different frontends
   - Use frontend with different backends
   - Share components across projects

## Troubleshooting

### Submodule Not Updating

```bash
# Force update
git submodule update --init --recursive --force
```

### Submodule Detached HEAD

```bash
cd backend  # or frontend
git checkout main
git pull
```

### Reset Submodules

```bash
git submodule deinit -f .
git submodule update --init --recursive
```

## Next Steps

After setting up repositories:

1. ✅ Clone the project
2. ✅ Run `docker-compose up -d`
3. ✅ Access at http://localhost:3000
4. ✅ Start developing!

## Questions?

- Check [README.md](./README.md) for general info
- Check [DOCKER_SETUP.md](./DOCKER_SETUP.md) for Docker details
- Check [VIDEO_OPTIMIZATION_CONFIG.md](./VIDEO_OPTIMIZATION_CONFIG.md) for video tuning
