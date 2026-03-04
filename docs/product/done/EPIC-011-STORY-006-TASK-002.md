# EPIC-011-STORY-006-TASK-002: Testsuite ausführen und Ergebnis prüfen

## Zugehörige Story
EPIC-011-STORY-006: Build-Verifikation und Tests

## Beschreibung
Die vollständige Testsuite ausführen und sicherstellen, dass alle Tests nach der Bereinigung weiterhin bestehen.

## Schritte
- [ ] Tests ausführen: `mvn test`
- [ ] Ausgabe auf `BUILD SUCCESS` und `Tests run: X, Failures: 0, Errors: 0` prüfen
- [ ] Bei Testfehlern: Ursache identifizieren (z. B. gelöschte Testressourcen, geänderte Klassen) und beheben
- [ ] Surefire-Report prüfen: `target/surefire-reports/`

## Ergebnis
Alle Tests laufen durch. `mvn test` endet mit `BUILD SUCCESS` ohne Failures oder Errors.

## Status
Todo

## Aufwand
XS
