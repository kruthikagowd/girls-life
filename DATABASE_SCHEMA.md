# PROJECT HER — Database Schema & Data Dictionary

All persistent user accounts, character customizers, inventories, social graphs, housing layouts, and economic transactions are maintained in **PostgreSQL**.

---

## 1. Relational Entity Relationship Diagram

```text
+------------------+          +--------------------+
|      users       | 1      * |     characters     |
|------------------|----------|--------------------|
| id (UUID, PK)    |          | id (UUID, PK)      |
| email (VARCHAR)  |          | user_id (UUID, FK) |
| username (VCH)   |          | doll_name (VARCHAR)|
| password_hash    |          | appearance (JSONB) |
| created_at       |          | updated_at         |
+------------------+          +--------------------+
         | 1
         |
         | *
+------------------+          +--------------------+
|    wallets       | 1      * |    transactions    |
|------------------|----------|--------------------|
| user_id (FK, PK) |          | id (UUID, PK)      |
| coins (BIGINT)   |          | user_id (UUID, FK) |
| style_pts (INT)  |          | amount (INT)       |
| updated_at       |          | type (VARCHAR)     |
+------------------+          | created_at         |
         |                    +--------------------+
         | 1
         |
         | *
+------------------+          +--------------------+
|   inventories    |          |    friendships     |
|------------------|          |--------------------|
| id (UUID, PK)    |          | id (UUID, PK)      |
| user_id (FK)     |          | user_id_a (FK)     |
| item_id (VARCHAR)|          | user_id_b (FK)     |
| item_type (VCH)  |          | status (VARCHAR)   |
| quantity (INT)   |          | relationship_level |
| metadata (JSONB) |          | updated_at         |
+------------------+          +--------------------+
         | 1
         |
         | 1
+------------------+          +--------------------+
|      houses      | 1      * | furniture_instances|
|------------------|----------|--------------------|
| id (UUID, PK)    |          | id (UUID, PK)      |
| user_id (FK, UK) |          | house_id (UUID, FK)|
| theme (VARCHAR)  |          | item_id (VARCHAR)  |
| unlocked_rooms   |          | pos_x, pos_y, pos_z|
| updated_at       |          | rot_y (FLOAT)      |
+------------------+          +--------------------+
```

---

## 2. Table Specifications & DDL

### 2.1 Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(32) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(16) DEFAULT 'player',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);
CREATE INDEX idx_users_username ON users(username);
```

### 2.2 Characters Table
```sql
CREATE TABLE characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    doll_name VARCHAR(32) NOT NULL,
    appearance_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_characters_user_id ON characters(user_id);
```

#### Sample `appearance_data` JSONB Structure:
```json
{
  "skin": {
    "tone_index": 2,
    "melanin_color": [0.95, 0.85, 0.78],
    "blush_intensity": 0.4
  },
  "face": {
    "eye_shape_index": 1,
    "eye_color": [0.35, 0.65, 0.85],
    "eyebrow_index": 3,
    "lip_color": [0.85, 0.35, 0.45],
    "lip_glossiness": 0.75
  },
  "hair": {
    "style_id": "hair_twin_tails_01",
    "primary_color": [0.25, 0.18, 0.15],
    "highlight_color": [0.55, 0.42, 0.35]
  },
  "outfit": {
    "top_id": "top_pastel_blouse_01",
    "bottom_id": "skirt_pleated_pink_01",
    "shoes_id": "shoes_mary_jane_01",
    "accessories": ["acc_pearl_necklace_01"]
  }
}
```

### 2.3 Wallets & Economy Ledger
```sql
CREATE TABLE wallets (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    coins BIGINT NOT NULL DEFAULT 1000 CHECK (coins >= 0),
    style_points INT NOT NULL DEFAULT 50 CHECK (style_points >= 0),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE economy_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    amount BIGINT NOT NULL,
    currency VARCHAR(16) NOT NULL, -- 'coins' | 'style_points'
    transaction_type VARCHAR(32) NOT NULL, -- 'job_reward' | 'shop_purchase' | 'trade'
    details JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_transactions_user ON economy_transactions(user_id);
```

### 2.4 Inventories Table
```sql
CREATE TABLE inventories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id VARCHAR(64) NOT NULL,
    item_type VARCHAR(32) NOT NULL, -- 'clothing' | 'furniture' | 'consumable'
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    metadata JSONB DEFAULT '{}'::jsonb,
    acquired_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, item_id)
);
CREATE INDEX idx_inventories_user_type ON inventories(user_id, item_type);
```

### 2.5 Houses & Furniture Instances
```sql
CREATE TABLE houses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    theme VARCHAR(32) DEFAULT 'pastel_dream',
    privacy_mode VARCHAR(16) DEFAULT 'friends_only', -- 'public' | 'friends_only' | 'private'
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE furniture_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    house_id UUID NOT NULL REFERENCES houses(id) ON DELETE CASCADE,
    item_id VARCHAR(64) NOT NULL,
    pos_x REAL NOT NULL,
    pos_y REAL NOT NULL,
    pos_z REAL NOT NULL,
    rot_y REAL NOT NULL DEFAULT 0.0,
    placed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_furniture_house ON furniture_instances(house_id);
```

### 2.6 Social Relationships & Friendships
```sql
CREATE TABLE friendships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id_a UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_id_b UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(16) NOT NULL DEFAULT 'pending', -- 'pending' | 'accepted' | 'blocked'
    relationship_tier VARCHAR(16) NOT NULL DEFAULT 'acquaintance', -- 'acquaintance' | 'friend' | 'close_friend' | 'dating'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id_a, user_id_b)
);
CREATE INDEX idx_friendships_users ON friendships(user_id_a, user_id_b);
```
