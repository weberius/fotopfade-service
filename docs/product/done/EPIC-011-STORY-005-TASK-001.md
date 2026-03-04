# EPIC-011-STORY-005-TASK-001: Legacy-Testressourcen entfernen

## Zugehörige Story
EPIC-011-STORY-005: Test-Ressourcen bereinigen

## Beschreibung
Entfernung der drei verwaisten `kulturpfad-muelheim.*`-Dateien aus `src/test/resources/`.

## Schritte
- [ ] Prüfen, dass keine Tests auf diese Dateien verweisen:
  `grep -r "kulturpfad-muelheim" src/test/java/` → kein Ergebnis erwartet
- [ ] `rm src/test/resources/kulturpfad-muelheim.json`
- [ ] `rm src/test/resources/kulturpfad-muelheim-poi.json`
- [ ] `rm src/test/resources/kulturpfad-muelheim.csv`
- [ ] Prüfen: `ls src/test/resources/ | grep muelheim` → kein Ergebnis

## Ergebnis
Die drei Legacy-Dateien sind entfernt. Die Testsuite bleibt unverändert lauffähig.

## Status
Todo

## Aufwand
XS
