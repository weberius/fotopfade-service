# EPIC-011-STORY-006-TASK-001: mvn clean package ausführen

## Zugehörige Story
EPIC-011-STORY-006: Build-Verifikation und Tests

## Beschreibung
Vollständigen Maven-Build durchführen, um sicherzustellen, dass der Service nach der Bereinigung fehlerfrei kompiliert und paketiert werden kann.

## Schritte
- [ ] Ins Projektverzeichnis wechseln: `cd /Users/wolfram/fotopfade/fotopfade-service`
- [ ] Build ausführen: `mvn clean package -DskipTests`
- [ ] Ausgabe auf `BUILD SUCCESS` prüfen
- [ ] Bei Fehlern: Ursache identifizieren (fehlende Ressourcen, Klassen-Referenzen) und beheben

## Ergebnis
`mvn clean package -DskipTests` endet mit `BUILD SUCCESS`.

## Status
Todo

## Aufwand
XS
