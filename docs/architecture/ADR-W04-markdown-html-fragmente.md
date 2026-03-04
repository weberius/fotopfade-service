# ADR-W04: Markdown- und HTML-Fragmente als pfadspezifische Inhaltsdateien

## Status
Accepted

## Kontext
Jeder Kulturpfad hat eigene Inhalte: POI-Beschreibungen, Willkommenstexte, Attributionen, Links, Disclaimer, Erwartungstexte. Diese Inhalte sind je nach Sprache unterschiedlich, werden von Redakteur*innen gepflegt und sollen ohne Programmierkenntnisse bearbeitbar sein. Es muss ein Format gewählt werden, das einfach editierbar ist und dynamisch in die Single-Page-App eingebettet werden kann.

## Entscheidung
Pfadspezifische Inhalte werden als **Markdown-Dateien** (`.md`) und **HTML-Fragmente** (`.html`) im Verzeichnis `locales/<namespace>/<sprache>/` abgelegt. Die Webapp lädt sie zur Laufzeit per `fetch()` und fügt sie mit `innerHTML` in den DOM ein:

- `.md`-Dateien werden über **marked.js** zu HTML konvertiert (`marked.parse()`)
- `.html`-Fragment-Dateien werden direkt als `innerHTML` eingefügt

Dateitypen pro Sprache:
| Datei | Inhalt |
|---|---|
| `p<nr>.md` | POI-Beschreibungstext (je ein File pro Wegpunkt) |
| `properties.json` | i18next UI-Strings und Sprachenliste |
| `startModalBody.md` | Willkommenstext beim Start |
| `aboutModalLi.md`, `expectModalLi.md`, etc. | Modal-Inhalte (Über / Features / Links) |
| `routModalBody.html` | Routentabellen-Template |
| `leaflet-control-attribution.html` | Leaflet-Attributions-HTML |
| `aboutTabsHeader.html` | Tab-Navigation im About-Modal |

## Begründung
- Markdown ist für Texterstellung ohne HTML-Kenntnisse geeignet und in Editoren wie VS Code direkt vorschaubar.
- Dateien sind einfach ins Git-Repository einzupflegen und zu versionieren.
- Kein serverseitiges CMS oder Datenbankbackend erforderlich.
- `fetch()`-Aufrufe ermöglichen lazy Loading – nur angezeigte Inhalte werden geladen.
- `marked.js` ist eine ausgereifte, sichere Markdown-Bibliothek (via CDN).

## Alternativen
- **Headless CMS (Contentful, Strapi)** – mächtiger, aber hoher Infrastrukturaufwand.
- **Alle Inhalte in `properties.json`** – einfacher Zugriff, aber Markdown-Formatierung in JSON nicht praktisch.
- **Asciidoc** – mächtiger für technische Dokumentation, aber schlechtere Browser-Unterstützung.

## Konsequenzen
### Positive
- Inhalte sind unabhängig von der Applikationslogik pflegbar.
- Eine neue Sprache erfordert nur das Anlegen eines neuen Sprachordners.
- Markdown ermöglicht einfache Formatierung (Überschriften, Listen, Links, Bilder).

### Negative / Risiken
- Jede `.md`-Datei wird mit einem eigenen `fetch()`-Request geladen – bei einem Pfad mit 50 POIs entstehen beim Kartenklick 50+ HTTP-Anfragen bei der ersten Interaktion.
- Fehlende Dateien (z. B. fehlende Übersetzung) erzeugen `404`-Fehler und leeren Inhalt ohne Nutzer-Rückmeldung.
- `innerHTML`-Setzung mit Remote-Inhalten birgt XSS-Risiko, wenn Inhalte von Dritten stammen. Aktuell vertrauenswürdig, da Dateien aus dem eigenen Projekt stammen.
- `marked.js` wird via CDN geladen – Ausfall oder Kompromittierung des CDN wirkt sich auf die Inhaltsanzeige aus.

## Auswirkungen
Betrifft: `assets/js/locale.js` (`ModalBuilder`), `assets/js/app.js` (POI-Klick-Handler), `locales/`-Verzeichnisstruktur.

## Datum
2026-03-04
