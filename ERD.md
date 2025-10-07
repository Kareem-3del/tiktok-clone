# Entity Relationship Diagram (ERD)
## TikTok-Like Social Video Platform

## Database Schema

### 1. Entities and Attributes

#### 1.1 Users
```
users
├── id (UUID, PK)
├── username (VARCHAR(30), UNIQUE, NOT NULL)
├── email (VARCHAR(255), UNIQUE, NOT NULL)
├── password_hash (VARCHAR(255), NOT NULL)
├── display_name (VARCHAR(50))
├── bio (TEXT)
├── profile_picture_url (VARCHAR(500))
├── is_verified (BOOLEAN, DEFAULT false)
├── followers_count (INTEGER, DEFAULT 0)
├── following_count (INTEGER, DEFAULT 0)
├── total_likes (INTEGER, DEFAULT 0)
├── created_at (TIMESTAMP, DEFAULT NOW())
├── updated_at (TIMESTAMP, DEFAULT NOW())
└── deleted_at (TIMESTAMP, NULL) -- Soft delete
```

#### 1.2 Videos
```
videos
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NOT NULL)
├── title (VARCHAR(150))
├── description (TEXT)
├── video_url (VARCHAR(500), NOT NULL)
├── thumbnail_url (VARCHAR(500))
├── duration (INTEGER) -- in seconds
├── file_size (BIGINT) -- in bytes
├── views_count (INTEGER, DEFAULT 0)
├── likes_count (INTEGER, DEFAULT 0)
├── comments_count (INTEGER, DEFAULT 0)
├── shares_count (INTEGER, DEFAULT 0)
├── is_private (BOOLEAN, DEFAULT false)
├── created_at (TIMESTAMP, DEFAULT NOW())
├── updated_at (TIMESTAMP, DEFAULT NOW())
└── deleted_at (TIMESTAMP, NULL) -- Soft delete
```

#### 1.3 Comments
```
comments
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NOT NULL)
├── video_id (UUID, FK -> videos.id, NOT NULL)
├── parent_comment_id (UUID, FK -> comments.id, NULL) -- For nested comments
├── content (TEXT, NOT NULL)
├── likes_count (INTEGER, DEFAULT 0)
├── created_at (TIMESTAMP, DEFAULT NOW())
├── updated_at (TIMESTAMP, DEFAULT NOW())
└── deleted_at (TIMESTAMP, NULL) -- Soft delete
```

#### 1.4 Likes
```
likes
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NOT NULL)
├── video_id (UUID, FK -> videos.id, NOT NULL)
├── created_at (TIMESTAMP, DEFAULT NOW())
└── UNIQUE(user_id, video_id) -- A user can like a video only once
```

#### 1.5 Comment Likes
```
comment_likes
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NOT NULL)
├── comment_id (UUID, FK -> comments.id, NOT NULL)
├── created_at (TIMESTAMP, DEFAULT NOW())
└── UNIQUE(user_id, comment_id) -- A user can like a comment only once
```

#### 1.6 Follows
```
follows
├── id (UUID, PK)
├── follower_id (UUID, FK -> users.id, NOT NULL) -- User who follows
├── following_id (UUID, FK -> users.id, NOT NULL) -- User being followed
├── created_at (TIMESTAMP, DEFAULT NOW())
└── UNIQUE(follower_id, following_id) -- A user can follow another user only once
```

#### 1.7 Hashtags
```
hashtags
├── id (UUID, PK)
├── name (VARCHAR(50), UNIQUE, NOT NULL)
├── usage_count (INTEGER, DEFAULT 0)
├── created_at (TIMESTAMP, DEFAULT NOW())
└── updated_at (TIMESTAMP, DEFAULT NOW())
```

#### 1.8 Video Hashtags (Junction Table)
```
video_hashtags
├── id (UUID, PK)
├── video_id (UUID, FK -> videos.id, NOT NULL)
├── hashtag_id (UUID, FK -> hashtags.id, NOT NULL)
├── created_at (TIMESTAMP, DEFAULT NOW())
└── UNIQUE(video_id, hashtag_id)
```

#### 1.9 Views (for analytics)
```
views
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NULL) -- NULL if not logged in
├── video_id (UUID, FK -> videos.id, NOT NULL)
├── watch_duration (INTEGER) -- in seconds
├── created_at (TIMESTAMP, DEFAULT NOW())
└── INDEX(video_id, user_id, created_at)
```

#### 1.10 Shares
```
shares
├── id (UUID, PK)
├── user_id (UUID, FK -> users.id, NOT NULL)
├── video_id (UUID, FK -> videos.id, NOT NULL)
├── share_type (ENUM: 'internal', 'external') -- internal = within app, external = outside
├── created_at (TIMESTAMP, DEFAULT NOW())
```

### 2. Relationships

#### 2.1 One-to-Many Relationships
- **Users → Videos**: One user can upload many videos
  - `users.id` (1) → (N) `videos.user_id`

- **Users → Comments**: One user can make many comments
  - `users.id` (1) → (N) `comments.user_id`

- **Videos → Comments**: One video can have many comments
  - `videos.id` (1) → (N) `comments.video_id`

- **Comments → Comments** (Self-referencing): One comment can have many replies
  - `comments.id` (1) → (N) `comments.parent_comment_id`

#### 2.2 Many-to-Many Relationships
- **Users ↔ Videos** (Likes): Many users can like many videos
  - Through junction table: `likes`

- **Users ↔ Comments** (Likes): Many users can like many comments
  - Through junction table: `comment_likes`

- **Users ↔ Users** (Follows): Many users can follow many users
  - Through junction table: `follows`

- **Videos ↔ Hashtags**: Many videos can have many hashtags
  - Through junction table: `video_hashtags`

- **Users ↔ Videos** (Views): Many users can view many videos
  - Through table: `views` (also stores analytics)

- **Users ↔ Videos** (Shares): Many users can share many videos
  - Through table: `shares`

### 3. Indexes (for Performance)

```sql
-- Users table
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Videos table
CREATE INDEX idx_videos_user_id ON videos(user_id);
CREATE INDEX idx_videos_created_at ON videos(created_at DESC);
CREATE INDEX idx_videos_likes_count ON videos(likes_count DESC);
CREATE INDEX idx_videos_views_count ON videos(views_count DESC);

-- Comments table
CREATE INDEX idx_comments_video_id ON comments(video_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_parent_id ON comments(parent_comment_id);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- Likes table
CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_likes_video_id ON likes(video_id);
CREATE INDEX idx_likes_created_at ON likes(created_at DESC);

-- Follows table
CREATE INDEX idx_follows_follower_id ON follows(follower_id);
CREATE INDEX idx_follows_following_id ON follows(following_id);

-- Hashtags table
CREATE INDEX idx_hashtags_name ON hashtags(name);
CREATE INDEX idx_hashtags_usage_count ON hashtags(usage_count DESC);

-- Video Hashtags table
CREATE INDEX idx_video_hashtags_video_id ON video_hashtags(video_id);
CREATE INDEX idx_video_hashtags_hashtag_id ON video_hashtags(hashtag_id);

-- Views table
CREATE INDEX idx_views_video_id ON views(video_id);
CREATE INDEX idx_views_user_id ON views(user_id);
CREATE INDEX idx_views_created_at ON views(created_at DESC);
```

### 4. ER Diagram (Text Representation)

```
┌─────────────┐
│    USERS    │
├─────────────┤
│ id (PK)     │◄──────────┐
│ username    │           │
│ email       │           │
│ password    │           │
│ ...         │           │
└─────────────┘           │
       ▲                  │
       │ 1                │
       │                  │
       │ N                │
┌─────────────┐           │
│   VIDEOS    │           │
├─────────────┤           │
│ id (PK)     │◄──────┐   │
│ user_id(FK) │───────┘   │
│ title       │           │
│ video_url   │           │
│ ...         │           │
└─────────────┘           │
       ▲                  │
       │ 1                │
       │                  │
       │ N                │
┌─────────────┐           │
│  COMMENTS   │           │
├─────────────┤           │
│ id (PK)     │           │
│ user_id(FK) │───────────┤
│ video_id(FK)│───────────┘
│ parent_id   │
│ content     │
│ ...         │
└─────────────┘

┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│    USERS    │     │      LIKES       │     │   VIDEOS    │
│             │     │                  │     │             │
│ id (PK)     │◄────│ user_id (FK)     │     │ id (PK)     │
│             │  N  │ video_id (FK)    │────►│             │
│             │     │ created_at       │  N  │             │
└─────────────┘     └──────────────────┘     └─────────────┘

┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│    USERS    │     │     FOLLOWS      │     │    USERS    │
│             │     │                  │     │             │
│ id (PK)     │◄────│ follower_id (FK) │     │ id (PK)     │
│             │  N  │ following_id(FK) │────►│             │
│             │     │ created_at       │  N  │             │
└─────────────┘     └──────────────────┘     └─────────────┘
  (Follower)                                    (Following)

┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│   VIDEOS    │     │ VIDEO_HASHTAGS   │     │  HASHTAGS   │
│             │     │                  │     │             │
│ id (PK)     │◄────│ video_id (FK)    │     │ id (PK)     │
│             │  N  │ hashtag_id (FK)  │────►│ name        │
│             │     │                  │  N  │ usage_count │
└─────────────┘     └──────────────────┘     └─────────────┘
```

### 5. Database Constraints

#### 5.1 Foreign Key Constraints
- ON DELETE CASCADE: `likes`, `comment_likes`, `follows`, `video_hashtags`, `views`, `shares`
- ON DELETE SET NULL: `comments.parent_comment_id`

#### 5.2 Check Constraints
```sql
-- Username validation
ALTER TABLE users ADD CONSTRAINT username_length 
  CHECK (char_length(username) >= 3 AND char_length(username) <= 30);

-- Video duration validation
ALTER TABLE videos ADD CONSTRAINT video_duration_limit 
  CHECK (duration > 0 AND duration <= 60);

-- Video file size validation (50MB max)
ALTER TABLE videos ADD CONSTRAINT video_file_size_limit 
  CHECK (file_size > 0 AND file_size <= 52428800);

-- Prevent self-follow
ALTER TABLE follows ADD CONSTRAINT no_self_follow 
  CHECK (follower_id != following_id);

-- Watch duration validation
ALTER TABLE views ADD CONSTRAINT watch_duration_validation 
  CHECK (watch_duration >= 0);
```

### 6. Sample Queries

#### 6.1 Get User Feed (For You Page)
```sql
SELECT v.*, u.username, u.profile_picture_url
FROM videos v
JOIN users u ON v.user_id = u.id
WHERE v.deleted_at IS NULL
  AND v.is_private = false
ORDER BY v.created_at DESC, v.likes_count DESC
LIMIT 20;
```

#### 6.2 Get Following Feed
```sql
SELECT v.*, u.username, u.profile_picture_url
FROM videos v
JOIN users u ON v.user_id = u.id
JOIN follows f ON f.following_id = v.user_id
WHERE f.follower_id = $userId
  AND v.deleted_at IS NULL
ORDER BY v.created_at DESC
LIMIT 20;
```

#### 6.3 Get Video with Comments
```sql
SELECT c.*, u.username, u.profile_picture_url
FROM comments c
JOIN users u ON c.user_id = u.id
WHERE c.video_id = $videoId
  AND c.deleted_at IS NULL
ORDER BY c.created_at DESC;
```

#### 6.4 Get Trending Hashtags
```sql
SELECT h.*, COUNT(vh.video_id) as recent_usage
FROM hashtags h
JOIN video_hashtags vh ON h.id = vh.hashtag_id
JOIN videos v ON vh.video_id = v.id
WHERE v.created_at >= NOW() - INTERVAL '7 days'
GROUP BY h.id
ORDER BY recent_usage DESC, h.usage_count DESC
LIMIT 20;
```

### 7. Caching Strategy (Redis)

```
Cache Keys:
- user:{userId} → User profile data (TTL: 1 hour)
- video:{videoId} → Video metadata (TTL: 30 minutes)
- feed:foryou:{userId} → For You page cache (TTL: 5 minutes)
- feed:following:{userId} → Following feed cache (TTL: 2 minutes)
- trending:hashtags → Trending hashtags (TTL: 15 minutes)
- video:comments:{videoId} → Video comments (TTL: 5 minutes)
- user:followers:{userId} → Follower list (TTL: 10 minutes)
```

### 8. Data Migration Notes

- Use TypeORM migrations for schema changes
- Implement soft deletes for data recovery
- Regular backups before major migrations
- Test migrations on staging environment first


