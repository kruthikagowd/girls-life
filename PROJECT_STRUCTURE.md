# PROJECT HER — Project Structure & Conventions

## 1. Directory Tree

```text
C:\girls-life\
├── .git/                      # Git version control metadata
├── .gitattributes             # Line ending normalization
├── .gitignore                 # Exclusion rules (caches, binaries, node_modules)
├── icon.svg                   # Project icon
├── project.godot              # Godot 4.7 engine configuration
├── PROJECT_OVERVIEW.md        # Master design pillars and specifications
├── GAME_ARCHITECTURE.md       # Architectural blueprints and subsystem contracts
├── DEVELOPMENT_ROADMAP.md     # 11-phase development roadmap and checklists
├── PROJECT_STRUCTURE.md       # Directory layout and coding standards
├── DATABASE_SCHEMA.md         # PostgreSQL database schemas and DDL
├── MULTIPLAYER_DESIGN.md      # Networking topology and synchronization protocol
├── ASSET_CREDITS.md           # Third-party attribution and licenses
├── CHANGELOG.md               # Version history and change records
│
├── prototypes/                # Early testing arenas and sandboxes
│   └── main.tscn              # Preserved prototype base scene (20x20 lit floor)
│
├── core/                      # Global singletons (Autoloads)
│   ├── GameEvents.gd          # Decoupled signal bus
│   ├── SessionManager.gd      # Authentication, user tokens, active doll profile
│   ├── NetworkManager.gd      # ENet and WebSocket client/server manager
│   ├── UIManager.gd           # Screen transitions, dialogs, alerts
│   └── EconomyManager.gd      # Client-side currency and inventory cache
│
├── characters/                # Doll mesh, customization, and animation assets
│   ├── doll/                  # DollBase scenes, bone sockets, character controller
│   ├── creator/               # Customization logic, appearance serializer
│   ├── materials/             # Shaders, skin tones, hair textures, eye materials
│   └── animations/            # Animation libraries (Walk, Run, Idle, Emotes)
│
├── scenes/                    # Main game scenes
│   ├── main_menu/             # Start menu, login, registration
│   ├── character_creator/     # Customization salon and preview stage
│   ├── city/                  # Shared multiplayer city hubs and districts
│   ├── housing/               # Player apartment interiors and furniture editor
│   └── jobs/                  # Work minigames (café, boutique, design studio)
│
├── ui/                        # User interface system
│   ├── themes/                # Godot Theme resources (pastel styling)
│   ├── components/            # Reusable widgets (buttons, modals, sliders)
│   ├── icons/                 # UI vector icons and badges
│   └── fonts/                 # Clean, modern typography
│
├── assets/                    # Raw static assets
│   ├── models/                # 3D glTF/GLB models for environment and props
│   ├── textures/              # Diffuse, normal, roughness texture maps
│   └── audio/                 # Sound effects, UI chimes, ambient music
│
└── server/                    # Node.js + TypeScript authoritative backend
    ├── package.json           # Dependencies and scripts
    ├── tsconfig.json          # TypeScript compiler configuration
    └── src/
        ├── server.ts          # Main Express / WebSocket entrypoint
        ├── auth/              # Registration, login, JWT validation
        ├── economy/           # Server-validated transactions and store
        ├── social/            # Real-time chat and presence gateway
        └── database/          # PostgreSQL client and schema migrations
```

---

## 2. Naming Conventions

- **Folders:** `snake_case` (e.g., `main_menu`, `character_creator`, `server`).
- **Scenes (.tscn):** `PascalCase` matching root node (e.g., `MainMenu.tscn`, `CharacterCreator.tscn`, `PlayerCharacter.tscn`).
- **Scripts (.gd):** `PascalCase.gd` matching scene class (e.g., `MainMenu.gd`, `SessionManager.gd`).
- **Resource files (.tres):** `snake_case.tres` (e.g., `pastel_theme.tres`, `skin_fair.tres`).
- **Variables & Functions:** `snake_case` (e.g., `var player_name: String`, `func update_appearance()`).
- **Constants:** `SCREAMING_SNAKE_CASE` (e.g., `const MAX_INVENTORY_SLOTS = 40`).
- **Signals:** Past tense or event phrase (e.g., `signal character_customized(data)`, `signal balance_updated(new_balance)`).
