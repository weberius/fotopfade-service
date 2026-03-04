# ADR-W01: Leaflet.js als interaktive Kartenbibliothek

## Status
Accepted

## Kontext
Die Webapp muss eine interaktive Karte darstellen, auf der POIs als Marker, Fußgängerrouten als Linienzüge und die GPS-Position des Nutzers angezeigt werden. Es wird eine leichtgewichtige, mobilfähige und erweiterbare Kartenbibliothek benötigt.

## Entscheidung
Als Kartenbibliothek wird **Leaflet.js 1.9.4** eingesetzt. Zusätzlich werden folgende Leaflet-Plugins verwendet:
- **leaflet.markercluster 1.5.3** – Clustering von POI-Markern bei geringem Zoom
- **leaflet-locatecontrol 0.81.0** – GPS-Ortung und Folgefunktion
- **leaflet.groupedlayercontrol** – Overlay-Verwaltung mit Gruppen (POI / Route)
- **Control.Coordinates** – Koordinatenanzeige beim Kartenklick

Basiskarten: OpenStreetMap Deutschland-Tile (`*.tile.openstreetmap.de`) und CartoDB Light.

## Begründung
- Leaflet ist die meistverbreitete Open-Source-Webkartenbibliothek mit umfangreichem Plugin-Ökosystem.
- Sehr gute Mobile- und Touch-Unterstützung.
- GeoJSON wird nativ durch `L.geoJson()` unterstützt – keine Konvertierung nötig, da das Backend GeoJSON liefert (ADR-005).
- Deutlich leichter als OpenLayers; ausreichend für die benötigten Funktionen.

## Alternativen
- **OpenLayers** – mächtiger, aber deutlich komplexer und größerer Bundle-Footprint.
- **Mapbox GL JS** – bessere Vektorkacheln, aber proprietäre Lizenz und API-Key-Pflicht.
- **Google Maps JavaScript API** – Nutzungskosten, Datenschutzbedenken, Vendor Lock-in.

## Konsequenzen
### Positive
- POI-GeoJSON und Routen-GeoJSON können direkt vom REST-Service geladen und gerendert werden.
- Hohes Plugin-Angebot deckt alle benötigten Funktionen (Cluster, GPS, Layercontrol) ab.
- Leaflet ist seit Version 1.x sehr stabil; Upgrades selten zwingend.

### Negative / Risiken
- Alle Leaflet-Plugins werden per CDN eingebunden (kein lokales Bundle), was Netz­abhängigkeit und potenzielle Versionskonflikte erzeugt.
- MarkerCluster und GroupedLayerControl sind Drittanbieter-Plugins mit eigenem Release-Zyklus.
- Kein reaktives Rendering; DOM-Manipulationen erfolgen imperativ via `L.DomUtil` und jQuery.

## Auswirkungen
Betrifft: `index.html`, `assets/js/app.js`, `assets/leaflet/`, `assets/control.coordinates/`.

## Datum
2026-03-04
