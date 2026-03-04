# EPIC-011-STORY-003-TASK-002: hannover-vonazu und koelnLindenthal1 Images entfernen

## Zugehörige Story
EPIC-011-STORY-003: Images entfernen

## Beschreibung
Entfernung der Image-Verzeichnisse der Routen `hannover-vonazu` (1 Datei) und `koelnLindenthal1` (16 Dateien).

## Schritte
- [ ] `rm -rf src/main/webapp/images/hannover-vonazu/`
- [ ] `rm -rf src/main/webapp/images/koelnLindenthal1/`
- [ ] Prüfen: `ls src/main/webapp/images/ | grep -E "hannover-vonazu|koelnLindenthal1"` → kein Ergebnis

## Ergebnis
Insgesamt 17 Bilddateien (1+16) aus den zwei Verzeichnissen entfernt.

## Status
Todo

## Aufwand
XS
