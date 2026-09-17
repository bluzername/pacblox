# PacBlox

A Pac-Man style arcade game for Roblox, written in Luau (about 2,600 lines across
server, client, and shared modules).

[![CI](https://github.com/bluzername/pacblox/actions/workflows/ci.yml/badge.svg)](https://github.com/bluzername/pacblox/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What it does

- Builds a 19x21 tile maze from a layout table on the server (`MazeGenerator`).
- Spawns a player character that moves along the grid with wall collision and
  input buffering for cornering (`PlayerController`).
- Places regular and power pellets, tracks score, and triggers power-up mode
  (`PelletManager`).
- Runs four ghosts with scatter, chase, frightened, and eaten states and one
  targeting personality each: Blinky (direct pursuit), Pinky (ambush ahead),
  Inky (unpredictable), Clyde (backs off when close) (`GhostAI`).
- Handles win (all pellets collected) and lose (caught by a ghost) conditions and
  the waiting, playing, power-up, victory, and game-over states (`GameManager`).
- Draws the HUD and an on-screen D-pad on touch devices (`UIManager`, `InputHandler`).
- Server-authoritative: the client only sends movement direction and renders state.

## Controls

| Input | Action |
|-------|--------|
| W / Up arrow | Move up |
| S / Down arrow | Move down |
| A / Left arrow | Move left |
| D / Right arrow | Move right |
| On-screen D-pad | Shown automatically when the device has touch and no keyboard |

## Getting the game into Roblox Studio

There are two ways. Rojo is the maintained path; the manual path needs no tools.

### Option A: Rojo (recommended)

1. Install [Rojo](https://rojo.space/docs/v7/getting-started/installation/)
   (7.x) and the Rojo plugin in Roblox Studio. If you use
   [aftman](https://github.com/LPGhatguy/aftman), `aftman install` in this
   folder installs the pinned `rojo`, `stylua`, and `selene`.
2. Either build a place file and open it:

   ```bash
   rojo build --output PacBlox.rbxl
   ```

   or live-sync into an open Studio place:

   ```bash
   rojo serve
   ```

   then click Connect in the Rojo plugin.
3. Press Play. The game starts when your character spawns.

`default.project.json` maps `src/` into the DataModel:

| Source | Roblox location | Class |
|--------|-----------------|-------|
| `src/shared/*.lua` | `ReplicatedStorage.Shared` | ModuleScript |
| `src/server/MainServer.server.lua` | `ServerScriptService.MainServer` | Script |
| `src/server/*.lua` | `ServerScriptService.*` | ModuleScript |
| `src/client/MainClient.client.lua` | `StarterPlayer.StarterPlayerScripts.MainClient` | LocalScript |
| `src/client/*.lua` | `StarterPlayer.StarterPlayerScripts.*` | ModuleScript |

### Option B: Manual copy into Studio

1. Open Roblox Studio, create a new Baseplate, and delete the default SpawnLocation.
2. In `ReplicatedStorage`, insert a `Folder` named `Shared`. Inside it insert a
   `ModuleScript` for each file in `src/shared/` (`Constants`, `GameEvents`,
   `Types`, `Utils`) and paste the file contents. Names are case-sensitive.
3. In `ServerScriptService`, insert a `Script` named `MainServer` with the contents
   of `src/server/MainServer.server.lua`, then a `ModuleScript` for each of
   `GameManager`, `MazeGenerator`, `PlayerController`, `GhostAI`, `PelletManager`,
   `SoundManager`.
4. In `StarterPlayer > StarterPlayerScripts`, insert a `LocalScript` named
   `MainClient` with the contents of `src/client/MainClient.client.lua`, then a
   `ModuleScript` for each of `InputHandler` and `UIManager`.
5. Press Play.

Troubleshooting: if nothing happens, check the Output window. The usual causes
are a module name typo, `MainServer` inserted as a ModuleScript instead of a
Script, or the `Shared` folder missing from `ReplicatedStorage`
(`SoundManager` requires `ReplicatedStorage.Shared.Constants`).

## Project structure

```
pacblox/
  default.project.json     Rojo project file
  aftman.toml              Pinned rojo / stylua / selene versions
  stylua.toml, selene.toml Formatter and linter config
  src/
    server/
      MainServer.server.lua  Entry point: initializes SoundManager and GameManager
      GameManager.lua        Game loop, states, player join/leave, win/lose
      MazeGenerator.lua      MAZE_LAYOUT table and wall/floor generation
      PlayerController.lua   Player character, grid movement, collision
      GhostAI.lua            Ghost models, states, personalities, targeting
      PelletManager.lua      Pellet placement, collection, scoring, power-up timer
      SoundManager.lua       Sound instances and playback (see Sounds)
    client/
      MainClient.client.lua  Client entry point, plays sounds sent by the server
      InputHandler.lua       Keyboard and touch input, sends direction to server
      UIManager.lua          Score, lives, and state HUD
    shared/
      Constants.lua          Grid sizes, colors, state enums, SOUND_IDS
      GameEvents.lua         RemoteEvent/BindableEvent helpers
      Types.lua              Data shapes and constructors
      Utils.lua              Grid and vector helpers
  assets/                  Notes on optional sounds and images (nothing shipped)
  .github/workflows/ci.yml stylua --check, selene, rojo build
```

## Customizing

Tunable values live at the top of the module that uses them:

| What | Where |
|------|-------|
| Maze layout (`1` wall, `2` pellet, `3` power pellet, `0` empty) | `MazeGenerator.MAZE_LAYOUT` |
| Cell size, wall height | `MazeGenerator.CELL_SIZE`, `MazeGenerator.WALL_HEIGHT` |
| Player speed | `PlayerController.MOVE_SPEED` |
| Ghost speeds and scatter/chase timings | `GhostAI.GHOST_SPEED`, `FRIGHTENED_SPEED`, `SCATTER_DURATION`, `CHASE_DURATION` |
| Pellet scores, power-up length | `PelletManager.PELLET_SCORE`, `POWER_PELLET_SCORE`, `POWER_UP_DURATION` |
| Colors, state names, sound ids | `src/shared/Constants.lua` |

`Constants.lua` also lists speed and score values, but the server modules
currently read their own module-level copies, so edit the module.

To add a ghost personality, add an entry to the `GhostPersonality` table at the
top of `src/server/GhostAI.lua`, a row in `GhostAI.init`, and a branch
in `GhostAI.getChaseTarget`.

## Sounds

Sounds are optional. No audio is shipped and every entry in
`Constants.SOUND_IDS` (`src/shared/Constants.lua`) is empty, so the game runs
silently. To enable a sound, upload an audio asset to Roblox and paste its id:

```lua
Constants.SOUND_IDS = {
    pelletCollect = "rbxassetid://1234567890",
    -- leave the rest empty to keep them silent
}
```

`SoundManager` skips any sound whose id is empty. `assets/sounds/README.md`
lists free sound sources.

## Development

```bash
aftman install          # or install rojo, stylua, selene yourself
stylua --check src      # formatting
selene src              # lint (std = roblox)
rojo build --output PacBlox.rbxl
```

CI runs the same three commands on every push and pull request. Formatting is
4 spaces, 120 columns (`stylua.toml`). Run `stylua src` before committing.

There is no automated test suite; test in Studio with Play, and with
Test > Start Server for multiple players.

## Known limitations

- Single maze layout, no level progression, no persistent high scores.
- Ghost pathfinding is a simple grid heuristic, not the arcade algorithm.
- Constants.lua duplicates some tunables that the server does not read (see above).

## Contributing

Fork, branch from `main`, run `stylua src` and `selene src`, test in Studio,
and open a pull request describing the change. Commit messages use
`type: description` (feat, fix, docs, refactor, chore, ci). See
`CONTRIBUTING.md` for the short version of the style rules.

## License and trademark notice

Code is released under the [MIT License](LICENSE). Pac-Man is a trademark of
Bandai Namco Entertainment; this is an unaffiliated fan project for learning
Roblox development.
