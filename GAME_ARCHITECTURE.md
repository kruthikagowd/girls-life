# PROJECT HER — Game Architecture Specification

## 1. System Architecture Overview

PROJECT HER uses a split client-server topology designed to decouple low-latency real-time spatial networking from persistent account and economy transactions.

```mermaid
graph TD
    subgraph Client["Godot Client (Desktop / Mobile)"]
        UI_Subsystem["UI Subsystem (Pastel Design System)"]
        Character_Subsystem["Character & Rigging Subsystem"]
        Movement_Subsystem["Locomotion & Camera Subsystem"]
        Housing_Subsystem["Grid Placement & Housing Subsystem"]
        Economy_Client["Economy & Inventory Client"]
        Net_Client["NetworkManager (ENet & WebSocket Client)"]

        UI_Subsystem --> Character_Subsystem
        Movement_Subsystem --> Net_Client
        Economy_Client --> Net_Client
        Housing_Subsystem --> Net_Client
    end

    subgraph DedicatedGameServer["Dedicated Godot Server (Headless)"]
        World_Sync["ENet Multiplayer Host"]
        Spatial_Grid["Area of Interest / Spatial Partitioning"]
        Physics_Validation["Authoritative Movement & Anti-Noclip"]
        World_Sync --> Spatial_Grid
        World_Sync --> Physics_Validation
    end

    subgraph BackendAPI["Backend Services (Node.js + TypeScript)"]
        Auth_Service["Auth & Session Service"]
        Economy_Service["Server-Authoritative Economy & Shop"]
        Social_Service["Presence, Friends & Moderated Chat"]
        House_Service["House Layout Persistence"]
    end

    subgraph Storage["Persistence Layer"]
        Postgres_DB[("PostgreSQL Database")]
    end

    Net_Client <-->|ENet / UDP (Port 7777)| World_Sync
    Net_Client <-->|HTTPS / REST API| BackendAPI
    Net_Client <-->|WSS (Port 8080)| Social_Service
    DedicatedGameServer <-->|Service Secret / JWT| BackendAPI
    BackendAPI <--> Postgres_DB
```

---

## 2. Client Autoload Singletons (`res://core/`)

| Singleton | Script Path | Responsibility |
| :--- | :--- | :--- |
| `GameEvents` | `res://core/GameEvents.gd` | Event bus for decoupling UI, game states, and world systems via signals. |
| `SessionManager` | `res://core/SessionManager.gd` | Holds active player JWT tokens, user ID, doll configuration, and session cache. |
| `NetworkManager` | `res://core/NetworkManager.gd` | Manages ENet multiplayer peer connection, RPC calls, and peer lifecycle. |
| `UIManager` | `res://core/UIManager.gd` | Coordinates transitions between screens, modal overlays, notifications, and alerts. |
| `EconomyManager` | `res://core/EconomyManager.gd` | Queries player balance and dispatches purchase requests to backend. |

---

## 3. Subsystem Breakdown

### 3.1 Character Doll Subsystem
- **Doll Rig:** Stylized humanoid armature compatible with standard humanoid bone mappings (Mixamo/VRM standard).
- **Socket System:** Standard attachment bones (`Socket_Hair`, `Socket_Head`, `Socket_Hat`, `Socket_Glasses`, `Socket_Hand_R`, `Socket_Hand_L`, `Socket_Back`).
- **Material Customizer:** Dynamic material property overrides for skin melanin, lip glossiness, iris color, eyebrow shape, and hair tint.

### 3.2 Movement & Camera Subsystem
- **CharacterBody3D Controller:** Implements `move_and_slide()` with acceleration, friction, jump physics, and rotation towards movement vector.
- **SpringArm3D Third-Person Camera:** Collision-aware camera boom preventing clipping through city architecture.

### 3.3 Housing Subsystem
- **Grid Snapping:** Orthogonal or 0.5m grid snapping for interior furniture placement.
- **Collision Boundary Check:** Prevents furniture from clipping through walls or other objects using AABB shape overlap testing.
- **Serialization:** Saves furniture instances as `[ { "id": "couch_01", "x": 2.5, "y": 0.0, "z": -1.0, "rot": 90 } ]`.

---

## 4. Hardware Optimization Guidelines

1. **Draw Call Budget:** Maintain < 150 draw calls per frame in city centers.
2. **Batching:** Use MultiMeshInstance3D for repetitive city props (streetlights, trees, park benches).
3. **Texture Sizing:** Standardize environment textures at 1024×1024 and character textures at 2048×2048.
4. **Shaders:** Rely on built-in StandardMaterial3D whenever possible to take advantage of Godot's internal material caching.
