# PROJECT HER — Project Overview

> **"Create your doll. Build your world. Live your story."**

## 1. Executive Summary

**PROJECT HER** is a multiplayer 3D virtual-world life simulation featuring hybrid anime-realistic fashion dolls. Players design and customize their own dolls, enter a shared virtual city, interact with real players, form friendships and romantic relationships, own and furnish homes, work diverse careers, and participate in a lively player-driven virtual economy.

PROJECT HER bridges the gap between high-end fashion doll aesthetic customization, anime visual appeal, and deep social MMO life simulation.

---

## 2. Core Pillars

1. **Expressive Doll Customization (Aesthetics First):**
   - Hybrid anime-realistic aesthetic: large expressive eyes, glossy lips, refined facial proportions, customizable skin tones, detailed hairstyles, and layered fashion garments.
   - Modular socket-based clothing and accessory attachment system.

2. **Shared Living City (Real-Time Social MMO):**
   - Server-authoritative multiplayer city where players gather, chat, gesture, and explore interactive venues like cafés, boutiques, salons, and parks.

3. **Autonomous Career & Economy Loop:**
   - Players earn virtual currency through career paths (café barista, fashion stylist, boutique assistant, corporate officer) and spend it on fashion, furniture, housing, and social activities.
   - Strict server-authoritative validation for all transactions; zero client-side trust.

4. **Personal Home System:**
   - Every player has access to personal residential spaces with real-time 3D grid placement of furniture, wall finishes, flooring, lighting, and guest invitations.

5. **Mutual Consent Social & Dating Simulation:**
   - Consensual, age-appropriate relationship mechanics including friend requests, hangout invitations, gift exchanges, and romantic dating activities.
   - Built-in moderation, profanity filtering, blocking, and player reporting.

---

## 3. Technology Stack

- **Client Engine:** Godot Engine 4.7.2 Stable (GL Compatibility / OpenGL ES3 for optimal performance on integrated graphics).
- **Client Scripting:** GDScript.
- **Physics Engine:** Godot 3D Physics / Jolt Physics.
- **3D Modeling & Assets:** Blender 4.x + glTF/GLB export pipeline.
- **Multiplayer State Sync:** Godot Dedicated Server using `ENetMultiplayerPeer` (Port 7777 UDP).
- **Backend Services:** Node.js (v22+) with TypeScript, Express/Fastify, and WebSockets.
- **Persistent Database:** PostgreSQL with structured relational schemas and JSONB metadata.
- **Security:** bcrypt password hashing, stateless JSON Web Tokens (JWT), and server-authoritative state checks.

---

## 4. Target Hardware & Optimization Profile

- **Target Dev Platform:** AMD Ryzen 7 5800HS, 16 GB RAM, AMD Radeon Integrated Graphics, Windows 11.
- **Rendering Method:** `gl_compatibility` (OpenGL ES3).
- **Optimization Strategy:**
  - Low-draw-call stylized shaders.
  - Mesh Level of Detail (LOD) and frustum culling.
  - Controlled texture resolutions (max 1024x1024 or 2048x2048 for hero doll textures).
  - Target framerate: Stable 60 FPS on integrated graphics.
  - Initial budget: ₹0, using free and legally verified CC0 / open-source assets.
