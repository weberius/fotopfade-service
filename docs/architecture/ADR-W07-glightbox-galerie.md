# ADR-W07: GLightbox für die Bildgalerie

## Status
Accepted

## Kontext
Die Webapp soll eine Bildgalerie anzeigen, in der die Fotos der POIs eines Kulturpfades durchblättert werden können. Die Galerie soll touch-fähig sein, einen Loop unterstützen und die Bilder in einer Lightbox (Vollbild-Overlay) darstellen.

## Entscheidung
Als Galerie-Komponente wird **GLightbox** eingesetzt (lokale Kopie in `assets/glightbox/`). Die Bildliste wird asynchron vom REST-Endpunkt `/service/gallery/<id>.json` geladen. Jedes Bild-Objekt enthält `href`, `type`, `title` und eine statische Copyright-Angabe (`description`).

Die Lightbox wird beim Seitenstart initialisiert (`GLightbox({...})`), sobald die Galeriedaten geladen sind. Der Galerie-Button in der Navbar öffnet die bereits initialisierte Instanz synchron (`galleryLightbox.open()`).

## Begründung
- GLightbox ist leichtgewichtig, benötigt kein jQuery und unterstützt Touch-Navigation nativ.
- Die einmalige Initialisierung beim Laden (statt beim Klick) vermeidet sichtbare Verzögerung beim Öffnen der Galerie.
- Das Backend liefert bereits die strukturierten Galerie-Daten (Bildpfade, Titel) als JSON; kein Frontend-seitiges CSV-Parsing nötig.
- Lokales Bundling (nicht CDN) vermeidet externe Abhängigkeit für diese Kernfunktion.

## Alternativen
- **Swiper.js** – umfangreicher (Carousel-Funktion), aber größerer Bundle.
- **PhotoSwipe** – sehr gute mobile UX, komplexere API.
- **Bootstrap Modal mit manueller Navigation** – kein zusätzliches Plugin, aber kein Touch-Swipe und mehr Eigenimplementierung.
- **Fancybox** – kommerziell für nicht-OSS-Projekte.

## Konsequenzen
### Positive
- Touch-Navigation (Swipe) und Keyboard-Navigation (Pfeiltasten, ESC) funktionieren out-of-the-box.
- Loop über alle Bilder des Pfades ohne zusätzliche Logik.
- Einfache Integration: ein `fetch()`-Call, ein `GLightbox({elements: ...})`-Aufruf.

### Negative / Risiken
- Der Galerie-Button hat in `gallery.js` **zwei identische Event-Listener** (`addEventListener("click", ...)`), was zu einem doppelten `open()`-Aufruf führt (Fehler / redundanter Code).
- Der `fetch()`-Aufruf in `gallery.js` verwendet `getURLParameter("id")` ohne Fallback auf `config.start.id`, falls kein `?id`-Parameter gesetzt ist – der Aufruf schlägt dann mit `null` im URL fehl.
- Copyright-Angabe `'Copyright © Wolfram Eberius'` ist hardcodiert in `gallery.js` – nicht pfadspezifisch konfigurierbar.

## Auswirkungen
Betrifft: `assets/js/gallery.js`, `assets/glightbox/`, REST-Endpunkt `/service/gallery/{id}.json`.

## Datum
2026-03-04
