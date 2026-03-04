# ADR-002: Dreischichtige Architektur (Controller – Service – Repository)

## Status
Accepted

## Kontext
Der REST-Service muss HTTP-Anfragen entgegennehmen, Geschäftslogik (Routing-Berechnung, Datenmapping) ausführen und auf Datenquellen (CSV-Dateien, OSM-Daten) zugreifen. Eine klare Trennung der Verantwortlichkeiten ist notwendig, um Testbarkeit und Wartbarkeit sicherzustellen.

## Entscheidung
Die Applikation ist in drei Schichten aufgeteilt:

1. **Controller-Schicht** (`controller/FotopfadeController`) – nimmt HTTP-GET-Anfragen entgegen, delegiert an Services, serialisiert die Antwort als JSON.
2. **Service-Schicht** (`services/`) – enthält die Geschäftslogik: POI-Klassifizierung, Routing-Vorbereitung, GeoJSON-Mapping, GPX-Erzeugung, Galerie-Aufbau.
3. **Repository-Schicht** (`repository/`) – kapselt den Datenzugriff hinter dem generischen Interface `JdbcRepository<T>`.

## Begründung
- Jede Schicht hat genau eine Aufgabe; Änderungen (z. B. Austausch der Datenquelle) wirken sich nur auf die jeweilige Schicht aus.
- Die Controller-Schicht bleibt schlank – keinerlei Geschäftslogik, nur HTTP-Handling und JSON-Serialisierung.
- Das Repository-Interface (`JdbcRepository<T>`) ermöglicht das Austauschen der Implementierung (z. B. von CSV zu JDBC/SQL) ohne Änderungen in den Services.

## Alternativen
- **Flache Architektur (alles im Controller)** – schneller zu implementieren, aber nicht wartbar.
- **Hexagonale Architektur (Ports & Adapters)** – besser für komplexe Domänenmodelle; für den aktuellen Umfang überdimensioniert.

## Konsequenzen
### Positive
- Klare Paketstruktur: `controller`, `services`, `repository`, `model`.
- Services und Repositories sind unabhängig vom HTTP-Kontext unit-testbar.
- Zukünftige Datenbank-Anbindung kann isoliert in der Repository-Schicht umgesetzt werden.

### Negative / Risiken
- Services werden derzeit im Controller direkt instanziiert (`new PoiService(id)`), statt per Dependency Injection eingebunden zu werden – dies untergräbt teilweise die Schichtentrennung (siehe ADR-007).
- Das `JdbcRepository`-Interface ist nach der künftigen Datenbankanbindung benannt, wird aber aktuell nur mit CSV-Lesern implementiert – die Benennung kann irreführend wirken.

## Auswirkungen
Alle Pakete des `fotopfade-service` sind betroffen:  
`de.illilli.fotopfade.controller`, `.services`, `.repository`, `.model`.

## Datum
2026-03-04
