# CHANGELOG — PROJECT HER

All notable changes, architectural milestones, and fixes are documented in this log.

---

## [0.1.0] - Phase 0: Project Inspection & Architecture Setup

### Added
- **Project Structure:** Established clean modular folder hierarchy (`core/`, `characters/`, `scenes/`, `ui/`, `assets/`, `server/`).
- **Core Master Documentation:**
  - `PROJECT_OVERVIEW.md`: Master vision, pillars, and technical specifications.
  - `GAME_ARCHITECTURE.md`: Subsystem design, singletons, and client-server topology.
  - `DEVELOPMENT_ROADMAP.md`: Detailed 11-phase roadmap with testing and checklist criteria.
  - `PROJECT_STRUCTURE.md`: File naming rules, directory map, and GDScript conventions.
  - `DATABASE_SCHEMA.md`: PostgreSQL DDL, schema definitions, and JSONB structures.
  - `MULTIPLAYER_DESIGN.md`: ENet packet structure, tick rates, and anti-cheat policies.
  - `ASSET_CREDITS.md`: License compliance ledger and attribution.
  - `CHANGELOG.md`: Change tracking system.
- **Git Repository:** Initialized local Git repository with configured `.gitignore` and `.gitattributes`.

### Fixed
- **Floor Collision Discrepancy (`prototypes/main.tscn`):**
  - Resolved major physics hazard where the visual floor was `Vector3(20, 0.2, 20)` while the collision shape was defaulting to `Vector3(1, 1, 1)`.
  - Updated `CollisionShape3D` to explicitly match `Vector3(20, 0.2, 20)`.
- **Scene Lighting & Environment:**
  - Added soft `DirectionalLight3D` with shadows.
  - Added anime-aesthetic pastel `WorldEnvironment` with procedural sky.
  - Added angled `Camera3D` to provide immediate visual feedback.
- **Project Configuration (`project.godot`):**
  - Updated title from `GirlsLife` to `PROJECT HER`.
  - Set `run/main_scene` to `res://prototypes/main.tscn`.
