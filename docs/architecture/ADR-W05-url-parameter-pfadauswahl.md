# ADR-W05: URL-Parameter für Pfadauswahl und Sprachwahl

## Status
Accepted

## Kontext
Die Webapp ist eine Single-Page-Application (SPA) ohne Server-seitiges Routing. Sie muss verschiedene Kulturpfade anzeigen können, ohne für jeden Pfad eine separate HTML-Seite zu benötigen. Außerdem soll die angezeigte Sprache direkt verlinks- und teilbar sein.

## Entscheidung
Pfad- und Sprachauswahl erfolgen über **URL-Query-Parameter**:

- `?id=<namespace>` – legt den anzuzeigenden Kulturpfad fest (z. B. `?id=frankenberg`)
- `?lng=<sprachcode>` – überschreibt die automatisch erkannte Browsersprache (z. B. `?lng=en`)

Fehlt `?id`, wird der Standardpfad aus `config.js` (`config.start.id`) verwendet.  
Fehlt `?lng`, ermittelt i18next BrowserLanguageDetector die Sprache automatisch.

Parameter werden über eine eigene Funktion `getURLParameter(name)` ausgelesen (implementiert in `config.js` und als Methode in der Klasse `URLParameter` in `app.js`).

## Begründung
- URL-Parameter sind der einfachste Mechanismus für zustandsbehaftete Links in einer SPA ohne Router-Bibliothek.
- Kulturpfad-Links können direkt per Copy-Paste geteilt werden (z. B. `index.html?id=moers&lng=en`).
- Kein serverseitiges Routing erforderlich – die Applikation läuft als reine Static-Web-App.
- Der Fallback auf `config.start.id` ermöglicht einen sinnvollen Startbeispiel ohne Parameter.

## Alternativen
- **Hash-basiertes Routing (`#`)** – kein Reload beim Wechsel, aber schlechtere Lesbarkeit und SEO.
- **History-API (`pushState`)** – saubere URLs, erfordert aber Server-seitige Weiterleitung aller Routen auf `index.html`.
- **LocalStorage** – persistiert Auswahl sitzungsübergreifend, aber nicht teilbar per Link.

## Konsequenzen
### Positive
- Jeder Kulturpfad ist als direkter, teilbarer Link aufrufbar.
- Kein JavaScript-Router nötig; einfache String-Verarbeitung genügt.
- Sprache lässt sich für Barrierefreiheit / Tests direkt per URL erzwingen.

### Negative / Risiken
- `getURLParameter` ist als globale Funktion in `config.js` definiert und wird in mehreren Dateien aufgerufen – implizite Abhängigkeit ohne Import.
- Dieselbe Funktion ist zusätzlich als Methode in der Klasse `URLParameter` (in `app.js`) reimplementiert – Code-Duplikation.
- Der Namespace wird beim Seitenstart einmalig aus dem URL-Parameter gelesen und dann in der globalen Variable `namespace` gehalten. Ein Pfadwechsel ohne Seitenreload ist nicht vorgesehen.
- Ungültige `?id`-Werte führen zu stillen `404`-Fehlern beim Laden von Locales und Service-Daten.

## Auswirkungen
Betrifft: `assets/js/config.js`, `assets/js/app.js` (Klasse `URLParameter`), `assets/js/locale.js`.

## Datum
2026-03-04
