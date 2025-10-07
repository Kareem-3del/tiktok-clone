# Docker Setup Guide - Complete Installation

This guide shows you how to run the entire VideoVibe recommendation system using Docker. **No additional software needed** - everything runs in containers including ffmpeg for video processing.

## Prerequisites

Only these are required:
- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 2.0 or higher)

That's it! Everything else (Node.js, PostgreSQL, Redis, MinIO, ffmpeg, etc.) is included in the containers.

## Quick Start (One Command)

```bash
docker-compose up -d
```

This single command will:
1. ✅ Start PostgreSQL database
2. ✅ Start Redis cache
3. ✅ Start MinIO object storage
4. ✅ Create storage buckets automatically
5. ✅ Build and start backend API (with ffmpeg included)
6. ✅ Build and start frontend
7. ✅ Run all migrations
8. ✅ Configure everything automatically

## Access the Application

Once everything is running:

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001/api/v1
- **MinIO Console:** http://localhost:9001 (credentials: minioadmin/minioadmin)
- **API Health:** http://localhost:3001/api/v1/health

## What's Included in Docker

### Backend Container
- ✅ Node.js 18
- ✅ **ffmpeg** - Video processing library (no installation needed!)
- ✅ **fluent-ffmpeg** - Node.js wrapper for ffmpeg
- ✅ **sharp** - Image optimization
- ✅ All video optimization features (FastStart, HLS, etc.)
- ✅ Progressive streaming support
- ✅ Automatic migrations

### Frontend Container
- ✅ Node.js 18
- ✅ Next.js with optimizations
- ✅ Progressive video loading
- ✅ Smart buffering and preloading

### Infrastructure
- ✅ PostgreSQL 15 - Database
- ✅ Redis 7 - Caching
- ✅ MinIO - Object storage (S3-compatible)

## Detailed Commands

### Start Everything
```bash
# Start all services in background
docker-compose up -d

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Stop Everything
```bash
# Stop all services
docker-compose down

# Stop and remove all data (⚠️ WARNING: Deletes database and videos!)
docker-compose down -v
```

### Rebuild After Code Changes
```bash
# Rebuild and restart
docker-compose up -d --build

# Rebuild specific service
docker-compose up -d --build backend
docker-compose up -d --build frontend
```

### View Service Status
```bash
# Check which containers are running
docker-compose ps

# Check container health
docker ps
```

## Environment Variables

The docker-compose.yml includes all necessary environment variables. You can customize them by creating a `.env` file:

```env
# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=videovibe

# MinIO Storage
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin

# JWT Secret (CHANGE IN PRODUCTION!)
JWT_SECRET=your-super-secret-jwt-key-change-in-production

# Video Optimization Settings
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=2
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=3
NEXT_PUBLIC_VIDEO_PRELOAD=metadata
NEXT_PUBLIC_ENABLE_PROGRESSIVE_STREAMING=true
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=3
```

## Container Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Docker Network                          │
│                   (videovibe-network)                       │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  PostgreSQL  │  │    Redis     │  │    MinIO     │    │
│  │  (Database)  │  │   (Cache)    │  │  (Storage)   │    │
│  │  Port: 5432  │  │  Port: 6379  │  │  Port: 9000  │    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
│         │                 │                  │             │
│         └─────────────────┴──────────────────┘             │
│                           │                                │
│                  ┌────────▼─────────┐                      │
│                  │     Backend      │                      │
│                  │   (NestJS API)   │                      │
│                  │   + ffmpeg ✅    │                      │
│                  │   Port: 3001     │                      │
│                  └────────┬─────────┘                      │
│                           │                                │
│                  ┌────────▼─────────┐                      │
│                  │     Frontend     │                      │
│                  │   (Next.js App)  │                      │
│                  │   Port: 3000     │                      │
│                  └──────────────────┘                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Video Processing in Docker

### How Video Encoding Works

When you upload a video:

1. **Upload** → Video sent to backend container
2. **ffmpeg Processing** (all in container, no host installation needed):
   - Extract video metadata
   - Generate thumbnail
   - Optimize with FastStart flag
   - Create preview clip (optional)
   - Generate HLS segments (optional)
3. **Storage** → Processed video saved to MinIO
4. **Streaming** → Progressive streaming to frontend

### Verify ffmpeg is Available

```bash
# Check ffmpeg in backend container
docker-compose exec backend ffmpeg -version

# Should output:
# ffmpeg version 6.x.x
# configuration: ...
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs backend

# Common issues:
# 1. Port already in use
#    Solution: Stop the service using the port or change ports in docker-compose.yml

# 2. Health check failing
#    Solution: Wait 30-60 seconds for services to fully initialize
```

### Database Connection Issues

```bash
# Check if PostgreSQL is ready
docker-compose exec postgres pg_isready -U postgres

# Run migrations manually
docker-compose exec backend npm run migration:run
```

### Video Upload Fails

```bash
# Check MinIO buckets exist
docker-compose exec backend curl http://minio:9000/minio/health/live

# Recreate buckets
docker-compose up -d createbuckets
```

### Performance Issues

```bash
# Check container resource usage
docker stats

# Allocate more resources to Docker Desktop:
# Settings → Resources → Advanced
# RAM: 4GB minimum, 8GB recommended
# CPU: 2 cores minimum, 4 cores recommended
```

### ffmpeg Not Working

This should NOT happen as ffmpeg is included in the container, but if you see errors:

```bash
# Verify ffmpeg installation in container
docker-compose exec backend which ffmpeg
# Should output: /usr/bin/ffmpeg

# Test ffmpeg
docker-compose exec backend ffmpeg -version
```

If ffmpeg is missing (very rare), rebuild the container:
```bash
docker-compose up -d --build backend
```

## Development Mode

For development with hot reload:

```bash
# Use docker-compose.dev.yml (if exists) or run services separately
docker-compose up -d postgres redis minio createbuckets

# Run backend locally
cd backend
npm install
npm run start:dev

# Run frontend locally
cd frontend
npm install
npm run dev
```

## Production Deployment

### Before Deploying to Production:

1. **Change JWT Secret:**
   ```env
   JWT_SECRET=use-a-strong-random-secret-key-here
   ```

2. **Change MinIO Credentials:**
   ```env
   MINIO_ROOT_USER=your-admin-user
   MINIO_ROOT_PASSWORD=your-strong-password-here
   ```

3. **Change Database Password:**
   ```env
   POSTGRES_PASSWORD=your-database-password
   ```

4. **Set Node Environment:**
   ```env
   NODE_ENV=production
   ```

5. **Configure CORS:**
   Update backend to allow only your frontend domain.

### Production Build

```bash
# Build optimized production images
docker-compose build --no-cache

# Start in production mode
docker-compose up -d

# Check health
docker-compose ps
```

## Data Persistence

All data is stored in Docker volumes:

- `postgres_data` - Database data (users, videos metadata)
- `redis_data` - Cache data
- `minio_data` - Video files and thumbnails

### Backup Data

```bash
# Backup PostgreSQL
docker-compose exec postgres pg_dump -U postgres videovibe > backup.sql

# Backup MinIO
docker-compose exec minio mc mirror /data ./minio-backup

# Backup Redis
docker-compose exec redis redis-cli SAVE
docker cp videovibe-redis:/data/dump.rdb ./redis-backup.rdb
```

### Restore Data

```bash
# Restore PostgreSQL
docker-compose exec -T postgres psql -U postgres videovibe < backup.sql

# Restore MinIO
docker cp ./minio-backup videovibe-minio:/data
```

## Cleaning Up

### Remove Unused Images

```bash
# Remove dangling images
docker image prune

# Remove all unused images
docker image prune -a
```

### Reset Everything

```bash
# Stop and remove containers, networks, and volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all -v

# Start fresh
docker-compose up -d
```

## System Requirements

### Minimum:
- 4GB RAM
- 2 CPU cores
- 10GB disk space

### Recommended:
- 8GB RAM
- 4 CPU cores
- 50GB disk space (for video storage)

### For Heavy Usage:
- 16GB RAM
- 8 CPU cores
- 100GB+ disk space

## Network Configuration

All services are on the `videovibe-network` bridge network. They can communicate using service names:

- `postgres` - Database host
- `redis` - Cache host
- `minio` - Storage host
- `backend` - API host
- `frontend` - Web host

## Next Steps

After successful deployment:

1. **Create Admin User** (if needed):
   ```bash
   docker-compose exec backend npm run seed
   ```

2. **Test Upload:**
   - Go to http://localhost:3000
   - Register an account
   - Try uploading a video
   - Check progressive loading works

3. **Monitor Logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Check Health:**
   ```bash
   curl http://localhost:3001/api/v1/health
   ```

## Support

If you encounter issues:

1. Check logs: `docker-compose logs -f`
2. Verify all containers are running: `docker-compose ps`
3. Check container health: `docker ps`
4. Review this guide again
5. Check VIDEO_OPTIMIZATION_CONFIG.md for video-specific settings

Remember: **Everything you need is in the containers!** You don't need to install ffmpeg, Node.js, PostgreSQL, or any other dependencies on your host machine.
