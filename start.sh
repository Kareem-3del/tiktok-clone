#!/bin/bash

echo "🚀 Starting VideoVibe Recommendation System..."
echo ""
echo "This will start all services including:"
echo "  ✅ PostgreSQL Database"
echo "  ✅ Redis Cache"
echo "  ✅ MinIO Storage"
echo "  ✅ Backend API (with ffmpeg for video processing)"
echo "  ✅ Frontend Web App"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: docker-compose not found!"
    echo "Please install docker-compose and try again."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

echo ""
echo "🏗️  Building and starting services..."
echo "This may take a few minutes on first run..."
echo ""

# Build and start all services
docker-compose up -d --build

# Wait for services to be healthy
echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Access your application at:"
echo "  🌐 Frontend:     http://localhost:3000"
echo "  🔧 Backend API:  http://localhost:3001/api/v1"
echo "  📦 MinIO Admin:  http://localhost:9001 (minioadmin/minioadmin)"
echo ""
echo "View logs with:"
echo "  docker-compose logs -f"
echo ""
echo "Stop all services with:"
echo "  docker-compose down"
echo ""
