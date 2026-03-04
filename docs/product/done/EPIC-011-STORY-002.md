# EPIC-011-STORY-002: Locales entfernen

## User Story
Als Entwickler möchte ich alle veralteten Locale-Verzeichnisse aus `src/main/webapp/locales/` entfernen, damit keine unnötigen Übersetzungsdateien mehr im Projekt verbleiben.

## Beschreibung
8 der 11 zu entfernenden Routen besitzen Locale-Verzeichnisse mit Übersetzungen in verschiedenen Sprachen. Diese werden vollständig gelöscht.

## Betroffene Verzeichnisse

| Verzeichnis                               | Sprachen           | Dateien (ca.) |
|-------------------------------------------|--------------------|---------------|
| `locales/05315000-b03-t01/`               | de, en             | ~30           |
| `locales/05315000-b03-t02/`               | de, en             | ~30           |
| `locales/05315000-b03-t03/`               | de, en             | ~30           |
| `locales/05315000-b03-t04/`               | de, en             | ~30           |
| `locales/05315000-b03-t05/`               | de, en, fr         | ~45           |
| `locales/05315000-b03-t06/`               | de, en             | ~30           |
| `locales/hannover-vonazu/`                | de                 | ~15           |
| `locales/koelnLindenthal1/`               | de, en             | ~30           |

Routen ohne Locales (`brunnentour`, `frankenberg-all`, `muelheim`) erfordern keinen Schritt in dieser Story.

## Akzeptanzkriterien
- [ ] Alle 8 Locale-Verzeichnisse vollständig entfernt
- [ ] `ls src/main/webapp/locales/` zeigt keines der betroffenen Verzeichnisse mehr
- [ ] Keine weiteren Referenzen auf die gelöschten Routen in verbleibenden Locale-Dateien

## Tasks
- EPIC-011-STORY-002-TASK-001: 05315000-b03-t0x Locales entfernen (6 Verzeichnisse)
- EPIC-011-STORY-002-TASK-002: hannover-vonazu Locales entfernen
- EPIC-011-STORY-002-TASK-003: koelnLindenthal1 Locales entfernen

## Abhängigkeiten
- Inhaltlich unabhängig von STORY-001 und STORY-003
- Muss vor STORY-006 (Build-Verifikation) abgeschlossen sein

## Geschätzte Komplexität
XS (< 30 Minuten)

## Status
To Do

## Datum
2026-03-04
