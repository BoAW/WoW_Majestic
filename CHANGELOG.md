# Majestic – Changelog

## 2.0.0
- **Removed TomTom dependency** – waypoints are now fully built-in (minimap pin, world map pin, HUD arrow)
- Waypoints now persist across `/reload` via SavedVariables
- World map and minimap icons use the addon's own icon texture (4621573)
- Tooltip overlay button now shows a dark background for readability
- Fixed: `/mj clear` now immediately updates visible tooltip overlay button text
- Fixed: overlay button text error on clear when overlays table was not yet initialised
- Removed obsolete `NoTomTom` locale strings from all 9 locales
- Removed "(TomTom)" label from `ClearDone` strings in all 9 locales

## 1.0.0
- Initial release
- Quest status check via `/mj status`, `/mj way`, `/mj all`, `/mj clear`
- TomTom integration for world map and minimap waypoints
- HUD directional arrow with drag, lock, and size options
- Tooltip overlay on lure spells/items showing availability and waypoint toggle
- Full localisation: enUS, deDE, esES, frFR, itIT, koKR, ptBR, ruRU, zhCN
- Addon icon texture and updated title added to TOC
- Fixed: locale encoding — replaced octal escape sequences with UTF-8 literals in frFR, deDE, esES, itIT
- Fixed: empty error output from locale files (frFR, koKR)
- Fixed: missing table endings in enUS locale

## 0.2.0
- Bumped version to 0.2.0
- Fixed: `MajesticCheckLureTooltip` nil error on `data.id` — extract spell/item ID via `GetSpell()`/`GetItem()` when no data argument is provided (legacy HookScript fallback)
- Fixed: locale encoding — replaced octal escape sequences with UTF-8 literals in frFR, deDE, esES, itIT, koKR

## 0.1.0
- Added lure tooltip status overlay showing "Available" (green) or "Skinned today" (red)
- Added clickable waypoint button on lure tooltip hover; hides on mouse leave
- Changed TomTom from `RequiredDeps` to `OptionalDeps`; login warning shown if missing
- Added locale keys across all 9 locales: `WaypointAdd`, `WaypointRemove`, `VersionLoaded`, `NoTomTom`, `DebugPrefix`, `DebugOn`, `DebugOff`
