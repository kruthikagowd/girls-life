# PROJECT HER — Master Development Roadmap

This document outlines the structured 11-phase development roadmap for **PROJECT HER**. Each phase represents an incremental, testable release.

---

## Roadmap Summary

- **Phase 0:** Project Inspection, Collision Fix & Foundation Setup
- **Phase 1:** Main Menu, UI Theme & Player Authentication
- **Phase 2:** 3D Fashion Doll Character Creator
- **Phase 3:** Third-Person Locomotion & Doll Animation State Machine
- **Phase 4:** First Multiplayer City & Authoritative ENet Synchronization
- **Phase 5:** Node.js + PostgreSQL Backend Integration & Persistent Profiles
- **Phase 6:** Friends, Social Systems & Moderated Chat
- **Phase 7:** Personal House System & Grid Interior Decoration
- **Phase 8:** Jobs, Career Minigames & Virtual Economy
- **Phase 9:** Dating, Relationships & Interactive Social Venues
- **Phase 10:** City Expansion, Polish, Integrated Graphics Optimization & Release Build

---

## Phase 0: Project Inspection & Foundation Setup

- **Objectives:**
  - Audit existing project files, engine settings, and hardware limits.
  - Fix floor collision discrepancy (default 1x1x1 vs 20x0.2x20 mesh).
  - Add lighting, world environment, and default camera.
  - Configure `project.godot` with project name and main scene.
  - Initialize Git repository and establish modular directory skeleton.
  - Generate core architectural documentation.
- **Required Files:**
  - `prototypes/main.tscn`
  - `project.godot`
  - `.gitignore`
  - Project documentation files (`*.md`)
- **Implementation:**
  - Set `CollisionShape3D` size to `Vector3(20, 0.2, 20)`.
  - Add `DirectionalLight3D` with shadows and pastel `WorldEnvironment`.
  - Update `config/name="PROJECT HER"` and `run/main_scene="res://prototypes/main.tscn"`.
  - Initialize Git and commit foundation files.
- **Testing Instructions:**
  - Execute Godot syntax validation: `Godot_v4.7.2-stable_win64.exe --headless --path . --check-only`.
  - Launch scene to confirm 20x20 lit platform.
- **Expected Results:** Zero errors, clean 60 FPS viewport with illuminated ground slab.
- **Known Limitations:** Static environment with no interactive avatars yet.
- **Checklist:**
  - [x] Floor collision shape matches mesh
  - [x] Git repository initialized
  - [x] Project name configured
  - [x] Documentation written
  - [x] Godot engine passes check-only validation

---

## Phase 1: Main Menu & Player Authentication

- **Objectives:**
  - Build the premium pastel UI design system (soft pinks, lavenders, creams, elegant fonts).
  - Create login and registration screens with input validation.
  - Implement `SessionManager` singleton for player session and token handling.
  - Provide offline / mock authentication mode for zero-barrier local testing.
- **Required Files:**
  - `ui/themes/pastel_theme.tres`
  - `scenes/main_menu/MainMenu.tscn`
  - `scenes/main_menu/MainMenu.gd`
  - `scenes/main_menu/LoginPanel.tscn`
  - `scenes/main_menu/LoginPanel.gd`
  - `core/SessionManager.gd`
  - `core/GameEvents.gd`
- **Testing Instructions:**
  - Launch `MainMenu.tscn`.
  - Test registration, login, error dialogues, and offline guest mode transition.
- **Expected Results:** Polished visual interface, smooth transitions, valid session token generated upon login.
- **Checklist:**
  - [ ] Pastel UI theme resource created
  - [ ] Login and registration UI complete
  - [ ] SessionManager handles user state
  - [ ] Offline demo login functional

---

## Phase 2: 3D Fashion Doll Character Creator

- **Objectives:**
  - Create the character customization viewport and camera.
  - Implement customizable doll features: skin tone, eye color, eyebrow style, lip gloss, hairstyle, and outfit palette.
  - Build character customization UI with tabs and color pickers.
  - Serialize and deserialize character customization data to JSON.
- **Required Files:**
  - `scenes/character_creator/CharacterCreator.tscn`
  - `scenes/character_creator/CharacterCreator.gd`
  - `characters/doll/DollBase.tscn`
  - `characters/doll/DollCustomizer.gd`
  - `characters/materials/skin_material.tres`
  - `characters/materials/hair_material.tres`
- **Testing Instructions:**
  - Launch `CharacterCreator.tscn`.
  - Change skin tone, hair, and eye colors; verify changes reflect instantly on the 3D doll.
  - Save character profile and verify output JSON structure.
- **Expected Results:** Real-time visual customization without stutter; valid appearance JSON exported.
- **Checklist:**
  - [ ] 3D Doll preview rig
  - [ ] Dynamic color/texture material properties
  - [ ] Creator UI controls (tabs, sliders, swatches)
  - [ ] JSON appearance serializer

---

## Phase 3: Character Movement & Locomotion State Machine

- **Objectives:**
  - Implement third-person player controller with responsive movement (walk, sprint, jump).
  - Add SpringArm3D orbit camera with mouse look and smooth rotation.
  - Set up animation state machine (Idle, Walk, Run, Jump, Fall).
  - Spawn the customized doll from Phase 2 inside the test prototype arena.
- **Required Files:**
  - `characters/doll/PlayerCharacter.tscn`
  - `characters/doll/PlayerCharacter.gd`
  - `characters/doll/ThirdPersonCamera.tscn`
  - `characters/doll/ThirdPersonCamera.gd`
  - `core/InputManager.gd`
- **Testing Instructions:**
  - Run `prototypes/main.tscn` with player spawn.
  - Test WASD movement, Shift sprint, Space jump, and camera panning across the full 20x20 platform.
- **Expected Results:** Fluid movement, correct collision with the floor, no jitter.
- **Checklist:**
  - [ ] CharacterBody3D locomotion physics
  - [ ] SpringArm3D smooth camera
  - [ ] Animation blending / states
  - [ ] Seamless integration with doll appearance data

---

## Phase 4: First Multiplayer City & Authoritative ENet Sync

- **Objectives:**
  - Create Godot ENet multiplayer manager (Host/Join/Dedicated Server modes).
  - Synchronize player positions, rotations, and animation states over UDP.
  - Spawn remote player puppets with their customized doll appearances.
  - Create the starter city hub prototype (public square, roads, sidewalks, basic buildings).
- **Required Files:**
  - `core/NetworkManager.gd`
  - `scenes/city/CityHub.tscn`
  - `characters/doll/RemotePlayerPuppet.tscn`
  - `characters/doll/RemotePlayerPuppet.gd`
- **Testing Instructions:**
  - Launch two instances of the game client on localhost (one as host or connect to local dedicated server).
  - Move Player 1 and verify Player 2 sees smooth movement and rotation.
- **Expected Results:** Real-time movement synchronization with linear interpolation (no snap teleporting).
- **Checklist:**
  - [ ] ENet client/server connection flow
  - [ ] Position interpolation for remote peers
  - [ ] Appearance synchronization across network
  - [ ] City prototype scene

---

## Phase 5: Node.js + PostgreSQL Backend & Persistent Profiles

- **Objectives:**
  - Build Node.js + TypeScript REST API.
  - Set up PostgreSQL database tables (`users`, `characters`, `inventories`).
  - Connect Godot `SessionManager` via HTTP to authentic backend endpoints.
  - Enable cloud persistence for doll customizations and account progress.
- **Required Files:**
  - `server/package.json`
  - `server/src/server.ts`
  - `server/src/database/db.ts`
  - `server/src/auth/authController.ts`
  - `server/src/characters/characterController.ts`
- **Testing Instructions:**
  - Run `npm run dev` in `server/`.
  - Register and login through the Godot client; verify new records in PostgreSQL.
- **Expected Results:** True client-server persistence with secure tokens.
- **Checklist:**
  - [ ] PostgreSQL schemas initialized
  - [ ] Node.js TypeScript API running
  - [ ] JWT authentication pipeline
  - [ ] Godot HTTPClient/HTTPRequest sync

---

## Phase 6: Friends, Chat & Social Systems

- **Objectives:**
  - Real-time text chat (Local city chat + Direct Messages).
  - Friend request system (search by player ID/username, send/accept/block).
  - Profanity filtering, rate limiting, and player reporting UI.
- **Required Files:**
  - `ui/components/ChatBox.tscn`
  - `ui/components/ChatBox.gd`
  - `ui/components/SocialHub.tscn`
  - `server/src/social/chatGateway.ts`
- **Testing Instructions:**
  - Exchange messages between two clients; verify filtering and blocking.
- **Checklist:**
  - [ ] Real-time WebSocket chat
  - [ ] Friend management interface
  - [ ] Safety and moderation rules

---

## Phase 7: Personal House System & Grid Interior Decoration

- **Objectives:**
  - Instanced personal apartment scene for every player.
  - 3D furniture placement system (select, move, rotate, snap to 0.5m grid).
  - Persistent room layout serialization.
  - Guest invitation system to allow friends into private apartments.
- **Required Files:**
  - `scenes/housing/ApartmentInterior.tscn`
  - `scenes/housing/FurniturePlacer.gd`
  - `scenes/housing/FurnitureCatalog.gd`
  - `server/src/housing/housingController.ts`
- **Testing Instructions:**
  - Place furniture items, save layout, leave apartment, re-enter, and verify layout reloads identically.
- **Checklist:**
  - [ ] Apartment 3D shell
  - [ ] Grid snapping and collision check
  - [ ] Layout serialization and database sync
  - [ ] Visiting permissions

---

## Phase 8: Jobs, Career Minigames & Virtual Economy

- **Objectives:**
  - Server-authoritative virtual currency system (`Coins` and `StylePoints`).
  - Career system: Café Barista, Fashion Stylist, and Boutique Associate.
  - Interactive job tasks/minigames to earn currency on a timer.
  - Fashion boutiques and furniture shops with server validation.
- **Required Files:**
  - `scenes/jobs/JobCenter.tscn`
  - `scenes/jobs/CafeJob.tscn`
  - `core/EconomyManager.gd`
  - `server/src/economy/economyController.ts`
- **Testing Instructions:**
  - Complete a café drink preparation task; verify server credit in PostgreSQL.
  - Purchase clothing item; verify deduction and inventory update.
- **Checklist:**
  - [ ] Server-validated currency ledger
  - [ ] Career minigame loop
  - [ ] Shop interface & inventory sync

---

## Phase 9: Dating, Relationships & Interactive Social Venues

- **Objectives:**
  - Consensual relationship progression (Acquaintance -> Friend -> Close Friend -> Romantic Interest -> Dating).
  - Mutual invitation workflow for romantic dates (café dinner, park stroll, cinema).
  - Dual-avatar interactive emotes and seating.
- **Required Files:**
  - `scenes/social/DateManager.gd`
  - `scenes/city/Venues/RomanticCafe.tscn`
  - `ui/components/RelationshipCard.tscn`
- **Testing Instructions:**
  - Invite friend to date; require receiver confirmation; trigger venue event upon acceptance.
- **Checklist:**
  - [ ] Mutual consent invite pipeline
  - [ ] Interactive paired seating and animations
  - [ ] Relationship milestone tracker

---

## Phase 10: City Expansion, Optimization & Release Build

- **Objectives:**
  - Expand city map with distinct aesthetic districts.
  - Optimize draw calls, LODs, occlusion culling, and texture memory for integrated graphics.
  - Add ambient city audio, footsteps, and background music.
  - Package standalone Windows client and headless server binaries.
- **Required Files:**
  - `scenes/city/ProjectHerCity_Full.tscn`
  - `export_presets.cfg`
- **Testing Instructions:**
  - Run continuous performance profile on AMD Ryzen 5800HS integrated GPU; verify solid 60 FPS under multi-player load.
- **Checklist:**
  - [ ] Full city optimization
  - [ ] Audio system complete
  - [ ] Export presets configured
  - [ ] Packaging and launch verification
