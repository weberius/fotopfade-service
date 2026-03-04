# EPIC-011-STORY-002-TASK-001: 05315000-b03-t0x Locales entfernen

## Zugehörige Story
EPIC-011-STORY-002: Locales entfernen

## Beschreibung
Entfernung der sechs Locale-Verzeichnisse der Routen `05315000-b03-t01` bis `05315000-b03-t06`.

## Schritte
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t01/`
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t02/`
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t03/`
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t04/`
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t05/`
- [ ] `rm -rf src/main/webapp/locales/05315000-b03-t06/`
- [ ] Prüfen: `ls src/main/webapp/locales/05315000* 2>/dev/null` → kein Ergebnis

## Ergebnis
Alle sechs Verzeichnisse mit ihren Unterverzeichnissen (de, en, fr) und allen Locale-Dateien sind entfernt.

## Status
Todo

## Aufwand
XS
