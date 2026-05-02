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
