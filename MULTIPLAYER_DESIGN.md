# PROJECT HER — Multiplayer Networking Design

## 1. Network Topology

PROJECT HER operates on a dual-protocol multiplayer architecture:

1. **Spatial Real-Time Synchronization (UDP / ENet via Godot Dedicated Server):**
   - High-frequency avatar movement, orientation, velocity, and locomotion animation states.
   - Low packet overhead, built-in Godot `MultiplayerSynchronizer` and `MultiplayerSpawner` support.
   - Authoritative collision verification preventing teleportation and boundary breaking.

2. **Transactional & Social Pipeline (WSS / HTTPS via Node.js Backend):**
   - Account authentication, token verification.
   - Economy transactions (buying fashion items, receiving job pay).
   - Chat distribution, friend graph, notifications, and dating invitations.

---

## 2. ENet State Synchronization Protocol

### 2.1 Tick Rate & Interpolation
- **Server Tick Rate:** 20 Hz (every 50ms).
- **Client Render Rate:** 60 FPS.
- **Client Prediction:** The local player predicts their own movement immediately via `CharacterBody3D.move_and_slide()`.
- **Remote Puppet Interpolation:** Remote avatars buffer received server snapshots and interpolate position using Hermite cubic spline or linear `Vector3.lerp()` with a 100ms jitter buffer.

### 2.2 Packet Payload Specification (Spatial Sync)
```text
[Header: 4 bytes (Peer ID)]
[Timestamp: 4 bytes (Float)]
[Position: 12 bytes (Vector3: X, Y, Z)]
[Yaw Rotation: 2 bytes (Half-Float)]
[Velocity: 6 bytes (Compressed Vector3)]
[Animation State: 1 byte (0=Idle, 1=Walk, 2=Run, 3=Jump, 4=Fall, 5=Emote)]
Total per packet: ~29 bytes
```

At 20 updates/second for 20 nearby players:
- Downstream bandwidth per client: `20 peers * 20 packets/s * 29 bytes ~= 11.6 KB/s`.
- Easily sustainable on integrated hardware and standard broadband connections.

---

## 3. Server Authority & Anti-Cheat Safeguards

1. **Movement Verification:**
   - The server simulates player collisions against the city navigation mesh / collision geometry.
   - Maximum speed cap: if distance traversed in delta `t` exceeds `max_sprint_speed * delta * tolerance_factor`, the server snaps the player back to their last valid verified transform.

2. **Zero-Trust Economy:**
   - The client never sends `player.coins += 500`.
   - The client sends an intent: `RPC_RequestJobCompletion(job_id, task_token)`.
   - The server verifies that the task duration elapsed legally and writes the ledger transaction directly to PostgreSQL.

3. **Rate Limiting & Flood Prevention:**
   - Chat packets are capped at 3 messages per 5 seconds.
   - Action intents are throttled per user token.
