# Changelog

## [1.6.0] - 2025-07-28

### Added

- Configurable Short Leg definition (18–30 darts)
- New statistics setting for the Short Leg definition
- Additional date filters:
  - Last 90 days
  - Last 3 months
  - Last 6 months
- Configurable finish button color
- Collapsible sections in the statistics settings dialog

### Changed

- Short Leg charts now respect the configured Short Leg definition
- Short Leg summary cards now respect the configured Short Leg definition
- Short Leg history now indicates entries that are excluded from statistics based on the configured definition
- Improved finish page color handling
- Improved finish button styling

### Refactored

- Renamed `ScoreChart` to `EntriesChart`

### Fixed

- Restored default finish colors after resetting the settings
- Various UI improvements and minor bug fixes


# [1.5.0] - 2026-07-23

## New

- Light and Dark Mode
- Customizable colors
- Appearance settings
- Finish chart
- Finish history
- Backup format v3

## Improved

- Immediate theme updates
- Improved backup compatibility
- Material 3 improvements
- Better dark mode contrast

## Fixed

- Import replaces finish history correctly
- Import supports legacy backup formats
- Theme and colors refresh immediately after import

---

## [1.4.0] - 2026-07-22

### ✨ New
- Added date range filter for statistics
- Added date range filter for finish tracker
- Added support for Double and Triple finish tracking
- Added separate statistics and charts for Double and Triple finishes
- Added finish multiplier to backup format
- Prepared iOS project for beta testing

### 🎨 Improved
- Baseline values are only applied when using the "Gesamt" date filter
- Improved finish chart labels (Double / Triple)
- Bull is hidden in Triple mode
- Improved filter layout for a cleaner UI

### 🔧 Changed
- Finish history now reflects the selected multiplier
- Finish charts now update according to the selected multiplier

### 🐞 Fixed
- Various UI improvements
- Several small stability fixes

---

## [1.3.0] - 2026-07-19

### Added
- New Finishes page
- Finish tracking with dedicated history
- Finish chart showing checkout distribution
- Finish grid for quick finish entry
- Finish multiplier selector (currently Double only)
- Backup support for finish entries
- Page selector for switching between Entries and Finishes

### Changed
- Refactored HomePage into RootPage, EntriesPage and FinishesPage
- Improved application structure and navigation
- Compact finish entry layout
- Reset now clears both entries and finishes

### Fixed
- Backup import/export compatibility for finish data

---

## [1.2.1] - 2026-07-20

### Fixed
- Swipe-Löschen öffnet jetzt einen Bestätigungsdialog.
- Die minimale Y-Achse berücksichtigt nun alle Startwerte (180, 171, 162, High Finish und Short Leg).
- Der Chart wird ausgeblendet, solange keine Einträge vorhanden sind.

---

## [1.2.0] - 2026-07-19

### Added
- Startwerte für High Finish und Short Leg.
- Möglichkeit zum Zurücksetzen aller Daten inklusive Startwerte.
- About-Dialog mit Informationen zur App.
- Automatische Anzeige von Versions- und Buildnummer.
- Neues App-Icon.

### Changed
- HomePage ist vollständig scrollbar.
- Einheitliche deutsche Bezeichnungen.
- Kalender beginnt am Montag.
- Startwerte werden auch im Chart für High Finish und Short Leg berücksichtigt.
- Verbesserter Backup-Import für alle Eintragstypen.
- Dynamische Chart-Achsen.

### Fixed
- Fehler beim Import von High Finish und Short Leg behoben.
- Mehrere kleinere Layout- und Overflow-Probleme beseitigt.

---

## [1.1.0] - 2026-07-18

### Added
- Backup exportieren.
- Backup importieren.
- Startwerte für 180, 171 und 162.
- Einstellungen zum Anpassen der Startwerte.

### Changed
- Diagramm berücksichtigt Startwerte bei der Darstellung.
- Überarbeitete Einstellungen und Datenspeicherung.

### Fixed
- Mehrere kleinere Fehlerbehebungen und Stabilitätsverbesserungen.

---

## [1.0.0] - 2026-07-16

### Features
- Erfassung von 180-, 171- und 162-Aufnahmen
- Diagramm mit konfigurierbaren Baselines
- Dashboard mit Statistiken
- Backup & Restore
- Material-3-Oberfläche

### Technisch
- SQLite mit Drift
- JSON-Backup
- Git-Versionierung