# EPIC-011-STORY-003: Images entfernen

## User Story
Als Entwickler möchte ich alle veralteten Image-Verzeichnisse aus `src/main/webapp/images/` entfernen, damit keine unnötigen Bilddateien mehr im Repository vorgehalten werden.

## Beschreibung
6 der 11 zu entfernenden Routen besitzen Image-Verzeichnisse mit Fotos und QR-Codes. Diese werden vollständig gelöscht.

## Betroffene Verzeichnisse

| Verzeichnis                          | Dateien |
|--------------------------------------|---------|
| `images/05315000-b03-t02/`           | 9       |
| `images/05315000-b03-t04/`           | 8       |
| `images/05315000-b03-t05/`           | 9       |
| `images/05315000-b03-t06/`           | 9       |
| `images/hannover-vonazu/`            | 1       |
| `images/koelnLindenthal1/`           | 16      |

Routen ohne Images (`05315000-b03-t01`, `05315000-b03-t03`, `brunnentour`, `frankenberg-all`, `muelheim`) erfordern keinen Schritt in dieser Story.

## Akzeptanzkriterien
- [ ] Alle 6 Image-Verzeichnisse vollständig entfernt (insgesamt 52 Dateien)
- [ ] `ls src/main/webapp/images/` zeigt keines der betroffenen Verzeichnisse mehr

## Tasks
- EPIC-011-STORY-003-TASK-001: 05315000-b03-t0x Images entfernen (4 Verzeichnisse)
- EPIC-011-STORY-003-TASK-002: Einzelne Routen Images entfernen (hannover-vonazu, koelnLindenthal1)

## Abhängigkeiten
- Inhaltlich unabhängig von STORY-001 und STORY-002
- Muss vor STORY-006 (Build-Verifikation) abgeschlossen sein

## Geschätzte Komplexität
XS (< 30 Minuten)

## Status
To Do

## Datum
2026-03-04
