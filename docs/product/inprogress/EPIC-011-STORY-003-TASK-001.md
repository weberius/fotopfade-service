# EPIC-011-STORY-003-TASK-001: 05315000-b03-t0x Images entfernen

## Zugehörige Story
EPIC-011-STORY-003: Images entfernen

## Beschreibung
Entfernung der vier Image-Verzeichnisse der Routen `05315000-b03-t02`, `05315000-b03-t04`, `05315000-b03-t05` und `05315000-b03-t06` (t01 und t03 haben keine Images).

## Schritte
- [ ] `rm -rf src/main/webapp/images/05315000-b03-t02/`
- [ ] `rm -rf src/main/webapp/images/05315000-b03-t04/`
- [ ] `rm -rf src/main/webapp/images/05315000-b03-t05/`
- [ ] `rm -rf src/main/webapp/images/05315000-b03-t06/`
- [ ] Prüfen: `ls src/main/webapp/images/05315000* 2>/dev/null` → kein Ergebnis

## Ergebnis
Insgesamt 35 Bilddateien (9+8+9+9) aus den vier Verzeichnissen entfernt.

## Status
Todo

## Aufwand
XS
