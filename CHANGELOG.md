# Changelog

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