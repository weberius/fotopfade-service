# ADR-W03: i18next für Mehrsprachigkeit mit hierarchischem Locales-Verzeichnis

## Status
Accepted

## Kontext
Die Anwendung soll mehrsprachig sein. Neben UI-Texten (Navigation, Buttons) müssen auch pfadspezifische Inhalte (POI-Beschreibungen, Modaltexte) sprachabhängig ausgeliefert werden. Die Sprache soll automatisch erkannt, aber auch manuell umschaltbar sein.

## Entscheidung
**i18next 23.x** wird mit folgenden Plugins eingesetzt:
- **i18next-browser-languagedetector** – erkennt automatisch die Browser-/OS-Sprache
- **i18nextHttpBackend** – lädt Übersetzungsdateien per HTTP nach

Übersetzungen werden als JSON-Dateien abgelegt:  
`locales/<namespace>/<sprache>/properties.json`

Der **Namespace** (`namespace`) entspricht der Kulturpfad-ID (z. B. `frankenberg`). Dadurch wird i18next auch als de-facto-Router für pfadspezifische Inhalte genutzt. POI-Beschreibungen (`p<nr>.md`), Modal-Inhalte (`.html`) und Audio-Dateien (`.mp3`) liegen ebenfalls unter `locales/<namespace>/<sprache>/`.

Die Sprache kann per URL-Parameter (`?lng=en`) oder über den Sprachselektor in der Navbar gewechselt werden.

## Begründung
- i18next ist die meistverbreitete JavaScript-Internationalisierungsbibliothek; gute Dokumentation und Pflege.
- Der HTTP-Backend-Loader ermöglicht lazy Loading – Übersetzungen werden nur bei Bedarf geladen.
- Die Kombination aus Namespace und Sprache ergibt einen natürlichen Verzeichnisbaum, der auch pfadspezifische Mediadateien strukturiert.
- Fallback auf Deutsch (`fallbackLng: 'de'`) sichert Mindestfunktion auch bei fehlenden Übersetzungen.

## Alternativen
- **vue-i18n / react-i18next** – frameworkgebunden; nicht passend für Vanilla-JS-Ansatz (ADR-W02).
- **Eigenes JSON-Mapping** – einfacher, aber kein automatischer Spracherkennung, kein Fallback-Mechanismus.
- **GNU gettext / Fluent** – mächtiger für viele Sprachen, aber kaum im Web-Kontext etabliert.

## Konsequenzen
### Positive
- Sprache wechselt vollständig ohne Seitenreload (`i18next.changeLanguage()`).
- Neue Sprachen können durch Hinzufügen eines Sprachordners unter `locales/<namespace>/` ergänzt werden, ohne JS-Änderungen.
- Browser-Spracherkennung ist transparent; Nutzer erhält sofort die richtige Sprache.

### Negative / Risiken
- `i18nextHttpBackend.js` ist lokal im `assets/`-Verzeichnis gebundled; Version muss manuell aktuell gehalten werden.
- Der Namespace (Pfad-ID) steuert auch, welche Locales geladen werden – ein falscher `namespace`-Wert führt stillschweigend zu leeren Inhalten.
- Alle POI-Markdown-Dateien müssen pro Sprache manuell gepflegt werden; fehlende Dateien erzeugen `404`-Fehler in der Browserkonsole (kein erkennbarer Fallback auf der UI).
- `properties.json` enthält UI-Strings und die Sprachenliste – eine Trennung dieser Belange wäre sauberer.

## Auswirkungen
Betrifft: `assets/js/locale.js`, `assets/js/config.js`, `assets/i18next/`, `locales/`-Verzeichnisstruktur.

## Datum
2026-03-04
