# ADR-W08: Fetch API für die REST-Service-Kommunikation

## Status
Accepted

## Kontext
Die Webapp muss Daten vom Spring-Boot-Backend laden: POI-Geometrien, Routen, Galerie-Listen, Routentabellen sowie pfadspezifische Inhalte (Markdown, HTML-Fragmente). Es muss ein Mechanismus für asynchrone HTTP-Anfragen im Browser gewählt werden.

## Entscheidung
Es wird die native **Fetch API** (`fetch()`) für alle direkten HTTP-Anfragen eingesetzt. Für die Routentabelle (DataTables) wird die **jQuery-AJAX-Integration von DataTables** (`ajax: { url, dataSrc }`) verwendet. GeoJSON-Layers werden über **jQuery `$.getJSON()`** geladen (Leaflet-Kompatibilität).

Muster für Verfügbarkeits-Check vor dem Laden:
```javascript
fetch(url, { method: 'HEAD' })
  .then(response => {
    if (response.ok) { $.getJSON(url, ...) }
    else { /* Fallback auf config.start.id */ }
  })
```

## Begründung
- `fetch()` ist seit ES2015 nativ in allen modernen Browsern verfügbar; kein Polyfill oder zusätzliche Bibliothek nötig.
- Promise-basierte API ermöglicht saubere Fehlerbehandlung mit `.catch()`.
- `$.getJSON()` wird für Leaflet-Kompatibilität beibehalten (Leaflet-Events basieren auf jQuery-Ajax-Lifecycle wie `ajaxStop`).
- Der `HEAD`-Request vor dem Laden verhindert, dass eine Service-404-Antwort Leaflet-Layer korrumpiert.

## Alternativen
- **Axios** – reichhaltigere API, Request-Cancellation, aber zusätzliche Abhängigkeit.
- **Ausschließlich `$.ajax()` / `$.getJSON()`** – konsistenter jQuery-Stil, aber veraltet.
- **XMLHttpRequest** – zu verbose; kein Vorteil gegenüber `fetch()`.

## Konsequenzen
### Positive
- Keine zusätzliche HTTP-Client-Bibliothek nötig.
- `fetch()` mit `method: 'HEAD'` ist ein eleganter Verfügbarkeits-Check ohne vollständigen Datentransfer.
- Fehlerbehandlung (`catch`) ist einheitlich für alle `fetch()`-Aufrufe implementiert.

### Negative / Risiken
- **Gemischter Einstil**: `fetch()`, `$.getJSON()` und DataTables-Ajax werden parallel eingesetzt – drei verschiedene Mechanismen für HTTP-Kommunikation.
- `fetch()` wirft bei HTTP-Fehlercodes (z. B. 404, 500) keine Exception; `response.ok` muss explizit geprüft werden. Dies ist in einigen `fetch()`-Aufrufen (z. B. in `ModalBuilder.loadMarkdown()`) korrekt implementiert, in anderen nur mit `catch()` abgesichert.
- `$(document).one("ajaxStop", ...)` in `app.js` reagiert nur auf jQuery-AJAX-Events, nicht auf native `fetch()`-Abschlüsse – das Zuschneiden der Kartenansicht (`fitBounds`) nach dem Laden basiert daher auf einem fragilen Timing-Mechanismus.
- Kein Request-Caching oder -Deduplication implementiert; redundante Anfragen (z. B. mehrfacher Klick auf denselben POI) werden jedes Mal neu gestartet.

## Auswirkungen
Betrifft: `assets/js/app.js`, `assets/js/locale.js` (`ModalBuilder`), `assets/js/gallery.js`.

## Datum
2026-03-04
