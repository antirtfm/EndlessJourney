# Endless Journey

A small [survivors-style](https://en.wikipedia.org/wiki/Vampire_Survivors) game built with [Felgo](https://felgo.com) (Qt 6 / QML + C++20) for the Felgo one-week challenge.

You control a knight across an endless field while enemies spawn, chase, and attack. Survive as long as you can: kills grant XP, level-ups offer power-ups, and difficulty ramps as the run goes on.

## Features

- Keyboard movement with sprint (stamina) and a mana-cost **nova** blast
- Auto-melee combat against a growing enemy roster (melee + ranged)
- XP / levels with three power-up choices and limited rerolls
- Pause, game over, and return-to-menu flow
- Scrolling world with a follow camera and 8-direction sprite animation
- Simulation in C++ (fixed timestep); presentation in QML

## Controls

| Input | Action |
|---|---|
| **W A S D** or arrow keys | Move |
| **Shift** | Sprint (drains stamina) |
| **Space** | Cast nova (costs mana) |
| **Esc** | Pause / resume |

On level-up, pick a power-up from the dialog (reroll available while charges remain).

## Architecture

**QML presents the game and sends intent; C++ owns state and rules.**

| Layer | Owns |
|---|---|
| QML (`qml/`) | Scenes, input intent, sprites, HUD, dialogs, effects |
| `GameEngine` | QML-facing commands, snapshots, fixed-step clock, game state |
| `World` + systems | Entities, spawning, movement, combat, progression |
| `EntityModel` | Stable QML list rows adapted from the C++ entity list |

Balance knobs live in `src/balance.h` (spawn curve, enemy roster, hero stats, etc.).

## Project layout

```
assets/          Hero and enemy directional sprite sheets
docs/            Long-form build tutorial and review materials
qml/             UI, scenes, HUD, input, rendering
  components/    Shared QML controls
  game/          World layer, entity views, VFX
  hud/           Bars, pause, game over, power-up dialog
  scenes/        Menu and gameplay scenes
src/             C++ simulation backend
  systems/       Combat, spawn, movement, enemy AI, progression
CMakeLists.txt
CMakePresets.json
main.cpp
```

## Build

Install the [Felgo SDK](https://felgo.com/download) first (includes a desktop Qt kit).

### Qt Creator (recommended, all platforms)

1. Open `CMakeLists.txt` in Qt Creator.
2. Select a Felgo desktop kit for your OS.
3. Configure, build, and run.

Kit names and compiler paths differ on Windows, macOS, and Linux; Qt Creator supplies the correct ones.

### Command line (Windows convenience preset)

The checked-in `felgo` preset is **Windows-only**. It assumes Felgo is installed at `C:\Felgo`. Edit paths in `CMakePresets.json` if you installed elsewhere.

```powershell
cmake --preset felgo
cmake --build --preset felgo
.\build\felgo-mingw\appEndlessJourney.exe
```

Release build:

```powershell
cmake --preset felgo-release
cmake --build --preset felgo-release
.\build\felgo-mingw-release\appEndlessJourney.exe
```

If a Felgo Hot Reload helper opens on launch, press **Connect** so it can load `qml/Main.qml`. A normal package build uses the embedded QML resources instead.

## Challenge context

Project created for the Felgo one-week challenge. Not an official Felgo product.
