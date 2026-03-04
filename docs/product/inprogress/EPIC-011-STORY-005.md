# EPIC-011-STORY-005: Test-Ressourcen bereinigen

## User Story
Als Entwickler möchte ich verwaiste Legacy-Testressourcen entfernen, damit `src/test/resources/` nur noch Dateien enthält, die von aktiven Tests verwendet werden.

## Beschreibung
Unter `src/test/resources/` existieren drei Dateien, die aus dem `kulturpfadservice` stammen und aktuell von keinem Test referenziert werden:

- `kulturpfad-muelheim.json`
- `kulturpfad-muelheim-poi.json`
- `kulturpfad-muelheim.csv`

Diese Dateien sind nach Entfernung von `muelheim.csv` vollständig obsolet.

## Akzeptanzkriterien
- [ ] `kulturpfad-muelheim.json` aus `src/test/resources/` entfernt
- [ ] `kulturpfad-muelheim-poi.json` aus `src/test/resources/` entfernt
- [ ] `kulturpfad-muelheim.csv` aus `src/test/resources/` entfernt
- [ ] Alle Tests laufen weiterhin erfolgreich durch (keine Testdatei referenziert die gelöschten Ressourcen)

## Tasks
- EPIC-011-STORY-005-TASK-001: Legacy-Testressourcen `kulturpfad-muelheim.*` entfernen

## Abhängigkeiten
- Inhaltlich unabhängig von allen anderen Stories
- Muss vor STORY-006 (Build-Verifikation und Tests) abgeschlossen sein

## Geschätzte Komplexität
XS (< 15 Minuten)

## Status
To Do

## Datum
2026-03-04
