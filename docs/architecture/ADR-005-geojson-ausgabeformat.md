# ADR-005: GeoJSON als Ausgabeformat für Geodaten

## Status
Accepted

## Kontext
Das JavaScript-Frontend verwendet eine Leaflet-Kartenbibliothek zur Visualisierung von POIs und Routen. Geographische Daten müssen zwischen Backend und Frontend ausgetauscht werden. Es wird ein Standardformat benötigt, das von Leaflet und gängigen Webkarten-Bibliotheken nativ unterstützt wird.

## Entscheidung
Alle Geodaten (POIs als Punkte, Routen als Linienzüge) werden als **GeoJSON** (`FeatureCollection`) ausgeliefert. Die Serialisierung erfolgt über die Bibliothek **geojson-jackson 1.14** (`de.grundid.opendatalab:geojson-jackson`), die eine direkte Jackson-Integration für GeoJSON-Objekte bietet.

Endpunkte:
- `/service/poi/{id}.geojson` → `FeatureCollection` aus `Point`-Features
- `/service/route/{id}.geojson` → `FeatureCollection` aus `LineString`-Features

## Begründung
- GeoJSON ist der De-facto-Standard für geografische Daten im Web (RFC 7946).
- Leaflet und alle gängigen JavaScript-Kartenbibliotheken können GeoJSON direkt rendern.
- `geojson-jackson` ermöglicht typsichere Java-Objekte (`Feature`, `FeatureCollection`, `Point`, `LineString`) ohne manuelle JSON-Konstruktion.
- Das Format ist menschenlesbar und mit Standard-JSON-Werkzeugen inspizierbar.

## Alternativen
- **WKT / WKB** – nicht direkt durch Browser-Bibliotheken konsumierbar.
- **KML** – XML-basiert, schlechtere JavaScript-Unterstützung, mehr Overhead.
- **Shapefile** – binär, nicht für REST-APIs geeignet.
- **Eigenes JSON-Format** – würde Frontend-Anpassungen erfordern und Standards ignorieren.

## Konsequenzen
### Positive
- Das Frontend kann die Antworten ohne Datentransformation direkt an `L.geoJSON()` übergeben.
- Zusätzliche Properties (Name, Nummer, Distanz, Zeit) können als `Feature.properties` mitgeliefert werden.
- GeoJSON-Dateien lassen sich zum Debuggen direkt im Browser oder in QGIS öffnen.

### Negative / Risiken
- Für sehr viele POIs/Wegpunkte kann die JSON-Größe relevant werden (kein Streaming/Compression konfiguriert).
- Die Bibliothek `geojson-jackson` fügt eine weitere Abhängigkeit hinzu; Kompatibilität mit Jackson-Versionen durch Spring Boot muss bei Updates geprüft werden.

## Auswirkungen
Betrifft: `PoiService`, `RouteServiceForFeatureCollection`, `FotopfadeController`.

## Datum
2026-03-04
