# EPIC-011-STORY-001: CSV-Dateien entfernen

## User Story
Als Entwickler möchte ich alle veralteten CSV-Konfigurationsdateien aus `src/main/resources/` entfernen, damit die Codebasis nur noch aktive Routen enthält.

## Beschreibung
11 CSV-Dateien sind nicht mehr aktiv genutzt und sollen vollständig aus dem Projekt entfernt werden. Die CSV-Dateien definieren die POI-Daten der jeweiligen Route und sind der zentrale Einstiegspunkt der Konfiguration.

## Betroffene Dateien

| Datei                         | Pfad                          |
|-------------------------------|-------------------------------|
| `05315000-b03-t01.csv`        | `src/main/resources/`         |
| `05315000-b03-t02.csv`        | `src/main/resources/`         |
| `05315000-b03-t03.csv`        | `src/main/resources/`         |
| `05315000-b03-t04.csv`        | `src/main/resources/`         |
| `05315000-b03-t05.csv`        | `src/main/resources/`         |
| `05315000-b03-t06.csv`        | `src/main/resources/`         |
| `brunnentour.csv`             | `src/main/resources/`         |
| `frankenberg-all.csv`         | `src/main/resources/`         |
| `hannover-vonazu.csv`         | `src/main/resources/`         |
| `koelnLindenthal1.csv`        | `src/main/resources/`         |
| `muelheim.csv`                | `src/main/resources/`         |

## Akzeptanzkriterien
- [ ] Alle 11 CSV-Dateien sind aus `src/main/resources/` entfernt
- [ ] Kein Build-Fehler durch fehlende Ressourcen
- [ ] `git status` zeigt die gelöschten Dateien korrekt an

## Tasks
- EPIC-011-STORY-001-TASK-001: 05315000-b03-t0x CSV-Dateien entfernen (6 Dateien)
- EPIC-011-STORY-001-TASK-002: Einzelne Routen CSV-Dateien entfernen (5 Dateien)

## Abhängigkeiten
- Muss vor STORY-006 (Build-Verifikation) abgeschlossen sein
- Inhaltlich unabhängig von STORY-002 und STORY-003

## Geschätzte Komplexität
XS (< 30 Minuten)

## Status
To Do

## Datum
2026-03-04
