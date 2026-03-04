# EPIC-011-STORY-004: Java-Code bereinigen – Fallback in PoiValuesRepository anpassen

## User Story
Als Entwickler möchte ich den Hard-coded Fallback auf `muelheim.csv` in `PoiValuesRepository.java` entfernen, damit der Service nach der Löschung der CSV-Datei keine fehlerhaften Referenzen mehr enthält.

## Beschreibung
In `src/main/java/de/illilli/fotopfade/repository/PoiValuesRepository.java` (Zeile 24) ist `muelheim.csv` als Default-Route eingetragen, wenn keine Route-ID übergeben wird:

```java
if (id == null || id.isEmpty()) {
    this.data = "/muelheim.csv";
}
```

Da `muelheim.csv` entfernt wird, muss diese Logik bereinigt werden. Die bevorzugte Lösung ist Option (b): Den Fallback entfernen und durch explizite Fehlerbehandlung ersetzen, da ein stiller Default-Fallback auf eine spezifische Route keine sinnvolle Semantik hat.

## Akzeptanzkriterien
- [ ] Kein Hard-coded Verweis auf `muelheim.csv` in `PoiValuesRepository.java`
- [ ] Bei leerem/null `id`-Parameter wird eine aussagekräftige Exception geworfen oder eine leere Liste zurückgegeben
- [ ] Bestehende Tests laufen weiterhin durch
- [ ] Build erfolgreich

## Tasks
- EPIC-011-STORY-004-TASK-001: Fallback-Strategie festlegen und `PoiValuesRepository.java` anpassen

## Abhängigkeiten
- Muss nach STORY-001-TASK-002 (Entfernung `muelheim.csv`) abgeschlossen sein
- Muss vor STORY-006 (Build-Verifikation) abgeschlossen sein

## Offene Frage
Soll bei `id == null || id.isEmpty()`:
- **(a)** eine leere Liste zurückgegeben werden (fail-silent), oder
- **(b)** eine `IllegalArgumentException` geworfen werden (fail-fast)?

## Geschätzte Komplexität
S (< 2 Stunden)

## Status
To Do

## Datum
2026-03-04
