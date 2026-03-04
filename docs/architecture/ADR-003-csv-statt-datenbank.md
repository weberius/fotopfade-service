# ADR-003: CSV-Dateien als primäre Datenhaltung für POIs

## Status
Accepted

## Kontext
POI-Daten (Name, Koordinaten, ID, Zoomstufe) müssen im Backend verfügbar sein. Sie werden sowohl für die GeoJSON-Ausgabe (Kartenanzeige) als auch für die Routing-Berechnung und die Galerie-Generierung benötigt. Es wird eine einfache, pflegbare und versionierbare Datenhaltung benötigt.

## Entscheidung
POI-Daten werden als **semikolon-getrennte CSV-Dateien** (`<id>.csv`) im Classpath (`src/main/resources/`) abgelegt. Der Zugriff erfolgt über `PoiValuesRepository` auf Basis der Bibliothek **OpenCSV** mit annotierten Java-Beans (`@CsvBindByPosition`).

Spaltenformat: `id ; name ; lat ; lng ; zoom`

Beispiele: `frankenberg.csv`, `moers.csv`, `koeln-innenstadt.csv`

## Begründung
- CSV-Dateien können ohne Datenbankserver betrieben werden – kein zusätzlicher Infrastrukturaufwand.
- Daten sind im Git-Repository versionierbar und lesbar ohne Spezialwerkzeuge.
- OpenCSV bietet robuste Bindung an Java-Beans mit minimalem Konfigurationsaufwand.
- Das Repository-Interface `JdbcRepository<T>` ist so gestaltet, dass ein späterer Umstieg auf eine echte Datenbank (H2GIS, PostGIS) ohne Änderungen an den Services möglich ist.
- Im Classpath abgelegte CSV-Dateien werden bei Build direkt ins JAR eingebettet.

## Alternativen
- **Relationale Datenbank (H2, SQLite, PostgreSQL)** – flexibler für Abfragen, aber Mehraufwand für Schema-Management und Betrieb. H2GIS ist bereits als Abhängigkeit vorhanden (vorbereitet).
- **GeoJSON-Dateien direkt** – würden die Repository-Schicht umgehen und Doppelarbeit erzeugen.
- **GeoPackage / Shapefile** – zu komplex für den heutigen Datenumfang.

## Konsequenzen
### Positive
- Einfache Pflege: eine CSV-Datei pro Kulturpfad, direkt im Projekt editierbar.
- Keine Laufzeit-Abhängigkeit auf externe Dienste.
- Liquibase ist bereits konfiguriert (`application.yaml`) und kann aktiviert werden, sobald auf eine Datenbank migriert wird.

### Negative / Risiken
- Kein SQL-Abfragemechanismus – komplexere Filter müssen in Java implementiert werden.
- Datenmenge skaliert nicht unbegrenzt (Einzeldateien pro Pfad).
- Schreibzugriffe (Editieren von POIs) sind über die API nicht möglich.
- Wird eine CSV-Datei für eine angefragte `id` nicht gefunden, gibt das Repository still eine leere Liste zurück (kein Fehlerhinweis an den Client).

## Auswirkungen
Betrifft: `PoiValuesRepository`, `GalleryService`, `PoiService`, `PrepareRouting`.  
Alle `*.csv`-Dateien unter `src/main/resources/`.

## Datum
2026-03-04
