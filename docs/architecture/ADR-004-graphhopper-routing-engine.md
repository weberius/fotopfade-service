# ADR-004: GraphHopper mit OSM-Daten für Fußgänger-Routing

## Status
Accepted

## Kontext
Die Anwendung muss zwischen aufeinanderfolgenden POIs realistische Fußgängerrouten berechnen. Die Routen sollen auf amtlichen Straßen- und Wegedaten basieren und offline – ohne externen Routing-Dienst – funktionieren.

## Entscheidung
Als Routing-Engine wird **GraphHopper 6.0** eingesetzt. Die Eingabedaten sind **OpenStreetMap PBF-Dateien** (`.osm.pbf`), die im Verzeichnis `osm/` des Projekts abgelegt werden. GraphHopper wird beim ersten Start (oder explizit per `BuildGraphHopperCache`) auf Basis der PBF-Datei indiziert; der Graph-Cache wird im Unterverzeichnis `osm/<name>-cache/` persistiert.

Konfiguration:
- Profil: `foot` (Fußgänger)
- Gewichtung: `fastest`
- Contraction Hierarchies (CH) aktiviert für Performance
- Keine Abbiege-Kosten (`turnCosts=false`)

## Begründung
- GraphHopper läuft vollständig lokal – kein API-Schlüssel, keine Netzwerkabhängigkeit, keine Kosten pro Anfrage.
- Die Open-Source-Lizenz (Apache 2.0) ist kompatibel mit dem Projektlizenzmodell.
- OSM-Daten decken alle verwendeten Regionen (Deutschland) ab und werden regelmäßig von Geofabrik bereitgestellt.
- CH-Profile ermöglichen sehr schnelle Anfragen nach einem einmaligen (teuren) Vorverarbeitungsschritt.
- Die OSM-Daten-URL ist als Maven-Property konfigurierbar (`download-osm.fromFile`), was den Austausch der Region vereinfacht.

## Alternativen
- **HERE Routing API / Google Maps Directions API** – externe Abhängigkeit, Kosten, Datenschutzbedenken.
- **OSRM** – ebenfalls OSM-basiert, aber in C++ implementiert und schwerer in JVM-Projekte integrierbar.
- **Valhalla** – ähnlich leistungsfähig, jedoch keine native Java-Bibliothek vorhanden.
- **OpenRouteService (lokal)** – Docker-basiert, höherer Betriebsaufwand.

## Konsequenzen
### Positive
- Vollständig offline betreibbar, keine laufenden Kosten.
- Schnelle Antwortzeiten nach dem Cache-Aufbau dank CH-Optimierung.
- Cache-Aufbau kann vom normalen Maven-Build (`BuildGraphHopperCache`) getrennt durchgeführt werden.

### Negative / Risiken
- PBF-Dateien sind groß (Regenbez.-Köln: mehrere GB); Cache-Aufbau dauert 5–15 Minuten.
- Die PBF-Datei und der Cache sind zu groß für das Git-Repository und müssen manuell bereitgestellt werden.
- Bei Anfragen außerhalb des PBF-Abdeckungsbereichs wird eine `RoutingNotAvailableException` geworfen.
- Regelmäßige Aktualisierung der OSM-Daten muss manuell angestoßen werden.

## Auswirkungen
Betrifft: `RoutingService`, `PrepareRouting`, `BuildGraphHopperCache`, `application.yaml`, `pom.xml` (Maven-Download-Plugin).  
Verzeichnis: `osm/`

## Datum
2026-03-04
