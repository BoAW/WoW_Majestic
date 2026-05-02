# Majestic – Changelog

## 2.0.0
- Removed TomTom dependency — waypoints fully built-in
- Waypoints persist across /reload (SavedVariables)
- Minimap and world map icons use addon texture
- Tooltip waypoint button now has a dark background
- /mj clear immediately updates overlay button text
- Fixed overlay nil error on first clear
- Removed obsolete `NoTomTom` locale strings from all 9 locales
- Removed "(TomTom)" label from `ClearDone` strings in all 9 locales
- Remove Current always visible in right-click menu
- Fixed arrow tracking wrong waypoint after removal
- Right-click lure selector shows all active waypoints
- Selected lure persists across /reload
- Shows "Go to <Zone>" when selected lure is on a different map
- Lure menu labels show creature and zone name

## 1.0.0
- Quest status: /mj status, /mj way, /mj all, /mj clear
- TomTom integration for minimap and world map
- HUD directional arrow (drag, lock, size)
- Lure tooltip overlay: Available / Skinned today
- Full localisation: 9 locales
- Addon icon and title added to TOC
- Fixed locale encoding (UTF-8 literals)
- Fixed: empty error output from locale files (frFR, koKR)
- Fixed: missing table endings in enUS locale

## 0.2.0
- Fixed nil error on tooltip data.id (legacy API)
- Replaced octal escape sequences in locale files

## 0.1.0
- Lure tooltip: Available (green) / Skinned today (red)
- Clickable waypoint button on lure tooltip hover
- TomTom changed from RequiredDeps to OptionalDeps
- Added locale keys across all 9 locales
