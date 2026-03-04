# EPIC-011-STORY-006-TASK-003: Git Commit erstellen

## Zugehörige Story
EPIC-011-STORY-006: Build-Verifikation und Tests

## Beschreibung
Alle Änderungen aus EPIC-011 (gelöschte Dateien, geänderter Java-Code, neue Dokumentation) in einem aussagekräftigen Git-Commit zusammenfassen.

## Schritte
- [ ] Status prüfen: `git status` – alle betroffenen Dateien als gelöscht/geändert anzeigen
- [ ] Alle Änderungen stagen: `git add -A`
- [ ] Commit erstellen:
  ```
  git commit -m "EPIC-011: Entfernung veralteter Routen-Konfigurationen

  Entfernt: 05315000-b03-t01..t06, brunnentour, frankenberg-all,
  hannover-vonazu, koelnLindenthal1, muelheim

  - 11 CSV-Dateien aus src/main/resources/ entfernt
  - 8 Locales-Verzeichnisse aus src/main/webapp/locales/ entfernt
  - 6 Image-Verzeichnisse aus src/main/webapp/images/ entfernt
  - PoiValuesRepository: muelheim-Fallback durch Fehlerbehandlung ersetzt
  - Legacy-Testressourcen kulturpfad-muelheim.* entfernt"
  ```
- [ ] Commit-Log prüfen: `git log --oneline -3`

## Ergebnis
Alle Änderungen sind in einem einzelnen, nachvollziehbaren Commit zusammengefasst.

## Status
Todo

## Aufwand
XS
