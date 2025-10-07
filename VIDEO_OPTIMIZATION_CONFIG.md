# Video Optimization Configuration Guide

This document explains the progressive video loading and streaming optimizations implemented in the recommendation system.

## Backend Optimizations

### 1. Progressive Video Encoding (FastStart)
**Location:** `backend/src/infrastructure/video-processing/video-processing.service.ts`

The `optimizeVideoForStreaming()` method applies the following optimizations:

```typescript
'-movflags faststart'  // Moves moov atom to start of file for instant playback
'-c:v libx264'         // H.264 codec for wide compatibility
'-preset fast'         // Fast encoding while maintaining quality
'-crf 23'              // Constant Rate Factor (quality: 18=high, 28=low)
'-profile:v baseline'  // Maximum device compatibility
'-level 3.0'           // Supports up to 720p
```

**What it does:**
- Places video metadata at the beginning so playback starts immediately
- Videos can start playing while still downloading
- First few seconds load quickly, rest streams progressively

### 2. HTTP Range Request Support
**Location:** `backend/src/adapters/http/controllers/video.controller.ts`

The streaming endpoint supports byte-range requests:
- Allows browsers to request specific portions of the video
- Enables seeking without downloading entire file
- Reduces initial load time by only fetching needed bytes

**Headers:**
- `Accept-Ranges: bytes` - Server supports partial requests
- `Content-Range` - Specifies which bytes are being sent
- `Cache-Control: public, max-age=31536000, immutable` - Long cache for performance

### 3. Preview Clip Generation
**Location:** `backend/src/infrastructure/video-processing/video-processing.service.ts`

The `generatePreviewClip()` method creates lightweight preview clips:
- First 3 seconds at lower quality (480p)
- Ultra-fast encoding preset
- No audio to reduce size
- Can play instantly while full video loads in background

### 4. HLS Adaptive Streaming (Optional)
**Location:** `backend/src/infrastructure/video-processing/video-processing.service.ts`

The `createAdaptiveStreamingManifest()` method generates HLS segments:
- Splits video into 2-second chunks
- Each chunk can be requested independently
- Browser can start playing after first chunk loads
- Adapts quality based on connection speed

**Configuration:**
- Segment duration: 2 seconds
- Format: MPEG-TS segments with M3U8 playlist
- Progressive download enabled

## Frontend Optimizations

### 1. Smart Preloading Strategy
**Location:** `frontend/src/components/feed/VideoFeed.tsx`

**Buffer Configuration:**
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=2  # Keep 2 videos before current loaded
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=3      # Keep 3 videos after current loaded
```

**What it does:**
- Only renders videos within buffer range (saves memory)
- Preloads 2-3 videos ahead and behind current video
- Unloads videos outside buffer range
- Uses browser prefetch hints for upcoming videos

### 2. Progressive Loading Indicator
**Location:** `frontend/src/components/video/VideoPlayer.tsx`

Features:
- Shows buffering progress percentage
- Spinner with progress bar for visual feedback
- Automatically hides when enough data is buffered
- Updates in real-time as video downloads

### 3. Video Player Optimizations
**Location:** `frontend/src/components/video/VideoPlayer.tsx`

```typescript
preload="metadata"           // Load only metadata first (fast)
controlsList="nodownload"    // Prevent download button
disablePictureInPicture={false}  // Allow PiP for better UX
```

**Buffering Logic:**
- Tracks buffered ranges
- Shows loading state until sufficient data is available
- Displays current buffered percentage
- Auto-plays when enough data is loaded

### 4. Link Prefetching
**Location:** `frontend/src/components/feed/VideoFeed.tsx`

```javascript
<link rel="prefetch" as="video" href="video_url.mp4" type="video/mp4">
```

- Browser preloads next 2-3 videos in background
- Uses idle network bandwidth
- Videos start instantly when user scrolls to them

## Environment Variables

### Frontend (.env.local)

```env
# Buffer size (number of videos to keep in memory)
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=2
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=3

# Preload strategy
NEXT_PUBLIC_VIDEO_PRELOAD=metadata  # Options: none, metadata, auto

# Progressive streaming
NEXT_PUBLIC_ENABLE_PROGRESSIVE_STREAMING=true

# Initial chunk size (seconds to buffer before playing)
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=3
```

### Backend (.env)

```env
# MinIO Storage Configuration
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_VIDEO_BUCKET=videos
MINIO_THUMBNAIL_BUCKET=thumbnails
```

## Performance Tuning

### For Slow Connections (3G/4G)
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=1
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=2
NEXT_PUBLIC_VIDEO_PRELOAD=metadata
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=2
```

### For Fast Connections (WiFi/5G)
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=3
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=5
NEXT_PUBLIC_VIDEO_PRELOAD=auto
NEXT_PUBLIC_VIDEO_INITIAL_CHUNK=5
```

### For Low Memory Devices
```env
NEXT_PUBLIC_VIDEO_BUFFER_PREVIOUS=1
NEXT_PUBLIC_VIDEO_BUFFER_NEXT=1
NEXT_PUBLIC_VIDEO_PRELOAD=none
```

## How It Works Together

1. **User opens app:**
   - First video metadata loads instantly (< 100ms)
   - Thumbnail shown while video initializes
   - First 3 seconds buffer quickly

2. **Video starts playing:**
   - Progressive streaming delivers video in chunks
   - Next 2-3 videos prefetch in background
   - Loading progress shown if buffering

3. **User scrolls to next video:**
   - Video already preloaded, plays instantly
   - Previous video unloaded to free memory
   - Next videos in queue start prefetching

4. **Network changes:**
   - Browser automatically requests appropriate byte ranges
   - Adapts buffer size based on connection speed
   - Pauses preloading if bandwidth constrained

## Monitoring & Debugging

### Check if FastStart is Applied
```bash
ffprobe video.mp4 2>&1 | grep "moov atom"
# Should show moov atom at start of file
```

### Check Buffered Ranges (Browser Console)
```javascript
const video = document.querySelector('video');
for (let i = 0; i < video.buffered.length; i++) {
  console.log(`Buffered: ${video.buffered.start(i)} - ${video.buffered.end(i)}`);
}
```

### Monitor Network Requests
- Open DevTools → Network tab
- Filter by "Media"
- Look for 206 (Partial Content) status codes
- Check Range request headers

### Performance Metrics
- Time to First Byte (TTFB): < 200ms
- First Frame: < 500ms
- Buffering events: < 2 per video
- Memory usage: ~50MB per buffered video

## Troubleshooting

### Videos Take Long to Load
1. Check if faststart flag is applied to videos
2. Verify MinIO is accessible and responsive
3. Increase BUFFER_NEXT to preload more aggressively
4. Enable HLS adaptive streaming

### High Memory Usage
1. Reduce BUFFER_PREVIOUS and BUFFER_NEXT
2. Set preload="none" instead of "metadata"
3. Implement video unloading when far from viewport

### Choppy Playback
1. Increase VIDEO_INITIAL_CHUNK
2. Check network bandwidth
3. Reduce video quality/bitrate during encoding
4. Enable adaptive streaming

### Slow Scrolling
1. Too many videos in buffer, reduce BUFFER values
2. Implement virtual scrolling
3. Lazy load thumbnails
4. Use IntersectionObserver for smarter loading
