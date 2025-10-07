# TikTok Clone

A modern, full-stack TikTok clone with progressive video streaming and intelligent feed algorithms. Built with NestJS, Next.js, and optimized for instant video playback.

## 🔗 Repositories

This project is split into multiple repositories:

- **Main:** [tiktok-clone](https://github.com/Kareem-3del/tiktok-clone) - Full project with Docker setup
- **Backend:** [backend-tiktok-clone](https://github.com/Kareem-3del/backend-tiktok-clone) - NestJS API
- **Frontend:** [frontend-tiktok-clone](https://github.com/Kareem-3del/frontend-tiktok-clone) - Next.js app

### Clone This Project

```bash
# Clone with all submodules
git clone --recursive https://github.com/Kareem-3del/tiktok-clone.git

# Or clone then init submodules
git clone https://github.com/Kareem-3del/tiktok-clone.git
cd tiktok-clone
git submodule update --init --recursive
```

## 🚀 Quick Start (Docker - Recommended)

**No installation needed except Docker!** Everything runs in containers including ffmpeg for video processing.

### Windows
```bash
start.bat
```

### Linux/Mac
```bash
chmod +x start.sh
./start.sh
```

**Or use Docker Compose directly:**
```bash
docker-compose up -d
```

That's it! The application will be available at:
- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:3001/api/v1

## ✨ Key Features

### 🎥 Video Optimization
- **Progressive Streaming** - Videos start playing from first frame
- **FastStart Encoding** - Metadata at beginning for instant playback
- **Chunked Loading** - Load 3-second chunks progressively
- **Smart Buffering** - Preload 2-3 videos ahead
- **HLS Support** - Adaptive streaming with 2-second segments
- **Preview Clips** - Quick 3-second low-quality previews

### 📱 TikTok-Style Features
- **Infinite Scroll Feed** - Seamless vertical scrolling
- **Double-Tap to Like** - Intuitive gesture controls
- **Comments & Shares** - Full social engagement
- **Hashtags & Search** - Content discovery
- **User Profiles** - Follow/Unfollow system
- **For You Feed** - Personalized recommendations

### ⚡ Performance
- **Videos load in < 500ms** - Optimized streaming
- **Memory efficient** - Only 2-3 videos buffered
- **Smart preloading** - Background prefetch
- **Range requests** - Seek without full download
- **Long caching** - Immutable content caching

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Next.js)                   │
│  - Progressive video player                             │
│  - Smart buffering & preloading                         │
│  - TikTok-style UI/UX                                   │
└───────────────────────┬─────────────────────────────────┘
                        │
                        │ HTTP/REST API
                        │
┌───────────────────────▼─────────────────────────────────┐
│                   Backend (NestJS)                      │
│  - Video processing (ffmpeg)                            │
│  - Progressive encoding                                 │
│  - Range request streaming                              │
│  - Recommendation engine                                │
└─────┬────────┬────────┬────────────────────────────────┘
      │        │        │
      │        │        │
┌─────▼────┐ ┌▼─────┐ ┌▼──────┐
│PostgreSQL│ │Redis │ │ MinIO/S3 │
│(Database)│ │(Cache)│ │(Files)│
└──────────┘ └──────┘ └───────┘
```

## 📋 What's Included

### Backend Features
- ✅ **Video Processing** (ffmpeg built-in)
  - FastStart encoding
  - Thumbnail generation
  - Preview clip creation
  - HLS manifest generation
- ✅ **Progressive Streaming**
  - HTTP range requests
  - Chunked transfer
  - Byte-range support
- ✅ **User Management**
  - JWT authentication
  - Profile system
  - Follow/Unfollow
- ✅ **Social Features**
  - Likes, comments, shares
  - Hashtags
  - Search
- ✅ **Recommendation Engine**
  - Personalized feed
  - Following feed
  - Trending videos

### Frontend Features
- ✅ **Video Player**
  - Progressive loading indicator
  - Native controls
  - Mute/Unmute
  - Buffer visualization
- ✅ **Feed System**
  - Infinite scroll
  - Smart preloading
  - Virtual rendering
  - Memory management
- ✅ **Interactions**
  - Double-tap to like
  - Heart animations
  - Comment dialogs
  - Share functionality
- ✅ **UI/UX**
  - Responsive design
  - Mobile-optimized
  - Haptic feedback
  - Loading states

## 🐳 Docker Services

The `docker-compose.yml` includes:

| Service | Description | Port |
|---------|-------------|------|
| **frontend** | Next.js web app | 3000 |
| **backend** | NestJS API + ffmpeg | 3001 |
| **postgres** | PostgreSQL 15 database | 5432 |
| **redis** | Redis 7 cache | 6379 |
| **minio** | S3-compatible storage | 9000, 9001 |
| **createbuckets** | Auto-creates MinIO buckets | - |

**All dependencies are containerized** - you only need Docker!

## 🎬 How Video Processing Works

1. **Upload**
   ```
   User uploads video → Backend receives file
   ```

2. **Processing** (All in Docker container with ffmpeg)
   ```
   Extract metadata → Generate thumbnail → Optimize with FastStart
   → Create preview clip → Upload to MinIO
   ```

3. **Streaming**
   ```
   Frontend requests video → Backend streams with range support
   → Browser plays progressively → Next videos preload in background
   ```

## ⚙️ Configuration

### Video Performance Tuning

Edit `.env` or `frontend/.env.local`:

```env
# Buffer size (number of videos in memory)
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=2  # Videos before current
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=3      # Videos after current

# Preload strategy
NEXT_PUBLIC_VIDEO_PRELOAD=metadata   # none | metadata | auto

# Progressive streaming
NEXT_PUBLIC_ENABLE_PROGRESSIVE_STREAMING=true

# Initial buffer size (seconds)
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=3
```

### For Different Network Speeds

**Slow Connection (3G/4G):**
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=1
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=2
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=2
```

**Fast Connection (WiFi/5G):**
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=3
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=5
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=5
```

**Low Memory Device:**
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=1
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=1
NEXT_PUBLIC_VIDEO_PRELOAD=none
```

## 📚 Documentation

- **[DOCKER_SETUP.md](./DOCKER_SETUP.md)** - Complete Docker deployment guide
- **[VIDEO_OPTIMIZATION_CONFIG.md](./VIDEO_OPTIMIZATION_CONFIG.md)** - Video optimization details
- Backend API docs - `/backend/README.md`
- Frontend docs - `/frontend/README.md`

## 🛠️ Development

### Local Development (without Docker)

**Prerequisites:**
- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- MinIO or S3
- **ffmpeg** (must be installed on host)

```bash
# Install ffmpeg
# Windows: Download from ffmpeg.org
# Mac: brew install ffmpeg
# Linux: sudo apt install ffmpeg

# Start infrastructure
docker-compose up -d postgres redis minio createbuckets

# Backend
cd backend
npm install
npm run start:dev

# Frontend
cd frontend
npm install
npm run dev
```

### With Docker (Recommended)

```bash
# Start everything
docker-compose up -d

# View logs
docker-compose logs -f

# Rebuild after changes
docker-compose up -d --build

# Stop everything
docker-compose down
```

## 🧪 Testing

```bash
# Backend tests
cd backend
npm run test
npm run test:e2e

# Frontend tests
cd frontend
npm run test
```

## 📊 Monitoring

### Check Service Health

```bash
# All services
docker-compose ps

# Backend health endpoint
curl http://localhost:3001/api/v1/health

# Check ffmpeg in container
docker-compose exec backend ffmpeg -version
```

### View Logs

```bash
# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Monitor Performance

```bash
# Container stats
docker stats

# Database connections
docker-compose exec postgres psql -U postgres -d videovibe -c "SELECT count(*) FROM pg_stat_activity;"
```

## 🔧 Troubleshooting

### Videos Not Loading

1. Check MinIO is accessible:
   ```bash
   curl http://localhost:9000/minio/health/live
   ```

2. Verify buckets exist:
   - Go to http://localhost:9001
   - Login: minioadmin/minioadmin
   - Check for `videos` and `thumbnails` buckets

3. Recreate buckets:
   ```bash
   docker-compose up -d createbuckets
   ```

### ffmpeg Errors

ffmpeg is included in the Docker container. Verify:

```bash
# Check ffmpeg installation
docker-compose exec backend ffmpeg -version

# Should show ffmpeg version 6.x.x
```

If missing, rebuild:
```bash
docker-compose up -d --build backend
```

### Slow Video Loading

1. Check network tab in browser DevTools
2. Verify 206 (Partial Content) responses
3. Adjust buffer settings in `.env`
4. Check container resources (RAM/CPU)

### Database Migrations

```bash
# Run migrations
docker-compose exec backend npm run migration:run

# Revert last migration
docker-compose exec backend npm run migration:revert
```

## 🚀 Production Deployment

### Before Production

1. **Change secrets in docker-compose.yml:**
   ```yaml
   JWT_SECRET: use-strong-random-secret
   MINIO_ROOT_USER: custom-user
   MINIO_ROOT_PASSWORD: custom-password
   POSTGRES_PASSWORD: custom-password
   ```

2. **Configure CORS** in backend for your domain

3. **Set up SSL/TLS** with nginx or Traefik

4. **Configure CDN** for MinIO/video delivery

5. **Set up backups** for PostgreSQL and MinIO

### Deploy

```bash
# Build production images
docker-compose build --no-cache

# Start in production
docker-compose up -d

# Check logs
docker-compose logs -f
```

## 📈 Performance Metrics

Expected performance with optimizations:

- **Time to First Byte:** < 200ms
- **First Video Frame:** < 500ms
- **Video Switch Time:** < 100ms (preloaded)
- **Buffering Events:** < 2 per video
- **Memory Usage:** ~50MB per buffered video

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

[Your License Here]

## 🆘 Support

- Check [DOCKER_SETUP.md](./DOCKER_SETUP.md) for detailed setup
- Review [VIDEO_OPTIMIZATION_CONFIG.md](./VIDEO_OPTIMIZATION_CONFIG.md) for tuning
- Check container logs: `docker-compose logs -f`
- Verify health: `docker-compose ps`

## 🎯 Roadmap

- [ ] WebRTC live streaming
- [ ] AI content moderation
- [ ] Advanced recommendation ML models
- [ ] Mobile apps (React Native)
- [ ] Video editor in-app
- [ ] Monetization features

---

**Remember:** Everything you need is in Docker! Just run `docker-compose up -d` and start building. 🚀
