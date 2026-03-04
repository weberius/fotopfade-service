# ADR-W06: Bootstrap 3 und CDN-Einbindung von Drittbibliotheken

## Status
Accepted

## Kontext
Die Webapp benötigt ein responsives UI-Framework für Navbar, Modals, Buttons und das Grid-Layout. Außerdem werden mehrere JavaScript- und CSS-Bibliotheken benötigt (Leaflet, jQuery, i18next, DataTables, etc.). Es muss entschieden werden, ob diese lokal gebündelt oder über CDN eingebunden werden.

## Entscheidung
Als UI-Framework wird **Bootstrap 3.3.5** verwendet (CSS + JS per CDN). Alle wesentlichen Drittbibliotheken werden als `<link>`- und `<script>`-Tags direkt aus öffentlichen CDNs geladen:

| Bibliothek | CDN |
|---|---|
| Bootstrap 3.3.5 | maxcdn.bootstrapcdn.com |
| Bootstrap Icons 1.11.3 | cdn.jsdelivr.net |
| Font Awesome 4.4.0 | maxcdn.bootstrapcdn.com |
| Leaflet 1.9.4 | cdnjs.cloudflare.com |
| leaflet.markercluster 1.5.3 | cdnjs.cloudflare.com |
| leaflet-locatecontrol 0.81.0 | cdnjs.cloudflare.com |
| jQuery 3.7.1 | cdnjs.cloudflare.com |
| Handlebars 3.0.3 | cdnjs.cloudflare.com |
| DataTables 2.0.3 | cdn.datatables.net |
| marked.js | cdn.jsdelivr.net |
| i18next 23.11.1 | cdnjs.cloudflare.com |
| i18next-browser-languagedetector | cdnjs.cloudflare.com |

Lokal im `assets/`-Verzeichnis gebundled: `glightbox`, `leaflet.groupedlayercontrol`, `control.coordinates`, `i18nextHttpBackend`.

## Begründung
- Keine Local-Build-Toolchain notwendig; Seite ist direkt aus dem Dateisystem oder via Spring Boot Static-Serving lauffähig.
- CDN-Ressourcen sind oft im Browser-Cache vorhanden (wenn andere Seiten dieselben CDN-URLs verwenden).
- Bootstrap 3 ist stabil und vollständig integriert; Migrations-Aufwand nach Bootstrap 5 wäre erheblich.
- Für Bibliotheken ohne stabiles CDN-Paket (GLightbox, GroupedLayerControl) wird lokales Bundling gewählt.

## Alternativen
- **Bootstrap 5** – moderner, kein jQuery mehr erforderlich, aber Breaking Changes.
- **Tailwind CSS** – utility-first, kein Grid/Modal out-of-the-box.
- **Lokale Kopien aller Bibliotheken (kein CDN)** – offline-fähig, aber höherer Wartungsaufwand bei Updates.
- **Webpack/Vite Build** – modular, tree-shaking, aber Build-Pipeline nötig.

## Konsequenzen
### Positive
- Kein Build-Schritt; Entwicklung ohne Node.js/npm möglich.
- Seite startet sofort nach dem `mvn`-Build ohne weitere Frontend-Tooling-Schritte.

### Negative / Risiken
- **Offline-Betrieb nicht möglich**: Alle CDN-Ressourcen erfordern Internetzugang beim ersten Laden (kein Service Worker / PWA-Cache).
- **Versionsfixierung per URL**: CDN-Versionsänderungen erfordern manuelle URL-Anpassungen in `index.html`.
- Bootstrap 3 und jQuery sind seit Jahren nicht mehr aktiv weiterentwickelt; Sicherheits-Patches könnten ausbleiben.
- Handlebars.js 3.0.3 ist in `index.html` eingebunden, ohne sichtbare Verwendung im eigenen Code – möglicher toter Code.
- CDN-Ausfall oder -Kompromittierung betrifft die Verfügbarkeit und Sicherheit der gesamten Anwendung (kein Subresource-Integrity-Hash).

## Auswirkungen
Betrifft: `index.html`, `assets/js/`, `assets/css/`, `assets/glightbox/`, `assets/leaflet/`, `assets/control.coordinates/`.

## Datum
2026-03-04
