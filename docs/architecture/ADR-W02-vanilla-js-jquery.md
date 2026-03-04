# ADR-W02: Vanilla JavaScript mit jQuery – kein SPA-Frontend-Framework

## Status
Accepted

## Kontext
Die Webapp benötigt dynamisches DOM-Rendering (Sidebar, Modals, Karteninteraktion) und asynchrone Datenkommunikation mit dem REST-Backend. Es muss entschieden werden, ob ein modernes SPA-Framework (React, Vue, Angular) oder klassisches imperatives JavaScript eingesetzt wird.

## Entscheidung
Die Webapp verwendet **Vanilla JavaScript (ES2020+)** mit **jQuery 3.7.1** für DOM-Manipulation, Event-Handling und AJAX-Aufrufe. Es wird kein Frontend-Build-Werkzeug (Webpack, Vite) und kein SPA-Framework eingesetzt. JavaScript-Dateien werden direkt als `<script>`-Tags in `index.html` eingebunden.

Struktur der eigenen JS-Dateien:
| Datei | Aufgabe |
|---|---|
| `config.js` | Startkonfiguration (Standard-Namespace, URL-Parameter) |
| `locale.js` | i18next-Initialisierung, `updateContent()`, Sprachumschaltung, `ModalBuilder` |
| `app.js` | Leaflet-Karte, Layer-Logik, Sidebar, Download-Menü |
| `gallery.js` | GLightbox-Galerie |

## Begründung
- Die Anwendung ist eine primär kartografische Single-Page-App mit wenig UI-Zustand; ein reaktives Framework ist überdimensioniert.
- Kein Build-Schritt erforderlich – Dateien werden direkt im `webapp`-Verzeichnis des Spring-Boot-JARs ausgeliefert.
- jQuery ist bereits transitiv durch Bootstrap 3 erforderlich.
- DOM-Struktur ist sehr stabil; die wenigen dynamischen Bereiche (Sidebar, Modals) lassen sich mit jQuery/Vanilla-JS gut beherrschen.

## Alternativen
- **Vue.js** – reaktiv, guter i18n-Support, moderater Overhead.
- **React** – am stärksten verbreitet, aber erheblicher Konfigurationsaufwand und Build-Toolchain.
- **Alpine.js** – minimales reaktives Framework, gute Ergänzung zu jQuery-lastigen Templates.

## Konsequenzen
### Positive
- Keine Build-Pipeline notwendig; Änderungen sofort sichtbar.
- Sehr geringe Einstiegshürde für Content-Pflegende ohne JS-Framework-Kenntnisse.
- Wartbarer Monolith: alle JS-Abhängigkeiten deklarativ in `index.html` sichtbar.

### Negative / Risiken
- Kein Modul-System: Globale Variablen (`map`, `pois`, `routes`, `namespace`, `languageCode`) erzeugen implizite Kopplung zwischen den Dateien.
- Klassen wie `ModalBuilder`, `URLParameter`, `LanguageSelector` sind global und nicht gekapselt.
- Kein Tree-Shaking oder Code-Splitting; alle Bibliotheken werden vollständig geladen, auch wenn nicht alle Features genutzt werden.
- jQuery und Bootstrap 3 sind technologisch veraltet (Bootstrap 3 EOL).

## Auswirkungen
Betrifft: `assets/js/app.js`, `assets/js/config.js`, `assets/js/locale.js`, `assets/js/gallery.js`, `index.html`.

## Datum
2026-03-04
