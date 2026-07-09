# Quickshell Config — Sakurafall

Personal [Quickshell](https://github.com/Quickshell/Quickshell) configuration, built on top of [StatIndet/quickshell](https://github.com/StatIndet/quickshell).

## Features

- **Bar** — Status bar with workspaces, active window, system tray, battery, clock, quick settings, and sys monitor
- **Dynamic Island** — Multi-purpose overlay: audio, media, clock, notifications, volume, weather, hub, lyrics, overview, and wallpaper content
- **Sidebars** — Left sidebar with weather info, notifications, and system view; right sidebar with audio/network/battery quick settings
- **Launcher** — App launcher, wallpaper picker, and window switcher (rofi-style)
- **Lock Screen** — Full-featured lockscreen with auth, music, weather, notifications, clock, and system grid
- **Control Center** — Theme, wallpaper, cursor, bezier curve editing, and general settings
- **Wallpaper** — Dynamic wallpaper background with swww/awww
- **Color System** — Material You / matugen dynamic color theming
- **Services** — Audio, bluetooth, brightness, media, network, notifications, tray, volume, wallpaper, wlsunset, and UI preferences
- **Common Widgets** — Reusable QML components (sliders, switches, buttons, progress bars, graphs, tooltips, etc.)

## Screenshots

> *(Add screenshots here)*

## Dependencies

### Required
- [Quickshell](https://github.com/Quickshell/Quickshell) — Qt6 QML shell
- [Clavis](https://github.com/Clavis/Clavis) — QML plugins for Niri IPC, audio spectrum, system monitor, weather, media, keyboard
  - Install from AUR: `libcava-git`, then build Clavis from source
- `awww` or `swww` — Wallpaper daemon
- `matugen` — Material You color generator

### Recommended
- `ttf-material-symbols-variable` — Material Symbols font
- `ttf-font-awesome` — Font Awesome icons
- Python 3 + `requests` — For weather/lyrics/schedule scripts

## Directory Structure

```
~/.config/quickshell/
├── AppShell.qml             # Root shell entry point
├── shell.qml                # Shell definition
├── controlcenter.qml        # Control center entry
├── core/                    # Clavis QML plugin builds
├── Components/              # Shared QML components
├── Common/                  # Common utilities, sizes, animations, paths
├── Modules/
│   ├── Bar/                 # Status bar
│   ├── ControlCenter/       # Settings panel
│   ├── DynamicIsland/       # Overlay notifications and content
│   ├── Launcher/            # App/wallpaper/window launcher
│   ├── Lock/                # Lock screen
│   ├── Sidebars/
│   │   ├── Left/            # Weather & notifications sidebar
│   │   └── Right/           # Quick settings sidebar
│   └── Wallpaper/           # Background rendering
├── Services/                # Backend services (audio, network, etc.)
├── Widgets/                 # Reusable UI widgets
│   ├── audio/
│   └── common/
├── scripts/                 # Helper scripts (weather, media, theme)
├── assets/                  # Icons and static assets
├── matugen/                 # Material You color templates
└── licenses/                # Third-party licenses
```

## Getting Started

1. Install Quickshell and Clavis
2. Clone this repo to `~/.config/quickshell/`
3. Run `quickshell` or add `exec quickshell ~/.config/quickshell/AppShell.qml` to your compositor config
4. (Optional) Run `generate_quickshell_colors.sh` to generate color scheme

## Credits

- Based on [StatIndet/quickshell](https://github.com/StatIndet/quickshell) — original QML shell configuration
- [Quickshell](https://github.com/Quickshell/Quickshell) — the shell framework
- [Clavis](https://github.com/Clavis/Clavis) — QML plugin suite

## License

This configuration is provided under the same license as the original work. See `licenses/` for details.
