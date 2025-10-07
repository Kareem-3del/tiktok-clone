# 🚀 Quick Start - 30 Seconds to Running App

## One-Line Installation

### Windows
```bash
start.bat
```

### Linux/Mac
```bash
chmod +x start.sh && ./start.sh
```

### Or use Docker Compose
```bash
docker-compose up -d
```

## That's It! ✅

Your application is now running at:

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001/api/v1
- **MinIO Admin:** http://localhost:9001

## What Just Happened?

Docker automatically:
1. ✅ Downloaded all images (PostgreSQL, Redis, MinIO, Node.js)
2. ✅ Installed **ffmpeg** for video processing (no manual install needed!)
3. ✅ Built your backend and frontend
4. ✅ Created database and ran migrations
5. ✅ Created storage buckets
6. ✅ Started all services

## No Installation Required!

You **DON'T** need to install:
- ❌ Node.js
- ❌ PostgreSQL
- ❌ Redis
- ❌ MinIO
- ❌ **ffmpeg** ← Especially this!
- ❌ Any other dependencies

Everything runs in Docker containers. Just install Docker and you're done!

## Test It Out

1. Go to http://localhost:3000
2. Register an account
3. Upload a video
4. Watch it load instantly with progressive streaming!

## Stop Everything

```bash
docker-compose down
```

## View Logs

```bash
docker-compose logs -f
```

## Need Help?

- Full setup guide: [DOCKER_SETUP.md](./DOCKER_SETUP.md)
- Video optimization: [VIDEO_OPTIMIZATION_CONFIG.md](./VIDEO_OPTIMIZATION_CONFIG.md)
- Implementation details: [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)
- Main README: [README.md](./README.md)

## Troubleshooting

### Port Already in Use?
Edit `docker-compose.yml` and change the port mappings:
```yaml
ports:
  - '3002:3000'  # Change 3000 to 3002
```

### Services Not Starting?
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f backend
```

### Want to Reset Everything?
```bash
# Remove all data and start fresh
docker-compose down -v
docker-compose up -d
```

That's all you need! Enjoy your TikTok-style video app with progressive streaming! 🎉
