# ADR-006: POI-ID-Schema und Punkt-Typ-Klassifizierung

## Status
Accepted

## Kontext
POIs in einem Kulturpfad haben unterschiedliche Rollen: reguläre Wegpunkte (Teil der Fußgängerroute), unverankerte Punkte (räumlich eigenständig, nicht Teil der Route), Punkte außerhalb der Route und Basisstationen. Diese Rollen müssen im Code und in den CSV-Daten eindeutig codiert sein, ohne große Infrastruktur bereitstellen zu müssen.

## Entscheidung
POI-IDs folgen dem Schema: `<ort>-<typ><nr>-<laufnr>`

- **`<typ>`** bestimmt den Punkt-Typ:
  - `p` – regulärer Ankerpunkt (Teil der Route, hat Foto)
  - `u` – unverankert (kein Routenpunkt, erscheint aber auf der Karte)
  - `o` – außerhalb der Route (`outOfRoute`)
  - `s` – Basisstation (`base`)

Beispiele: `frankenberg-p06-6`, `frankenberg-u01-7`, `moers-o02-3`

Die Klassifizierung wird in `AnchorType` (reguläre Ausdrücke) und die ID-Zerlegung in `IdParser` implementiert.

## Begründung
- Das ID-Schema ist selbstbeschreibend und benötigt keine zusätzliche Metadaten-Spalte in der CSV.
- `AnchorType` ermöglicht eine zentrale, einheitliche Typerkennung ohne Enum-Mapping.
- `IdParser` kann Ort, Laufnummer und Typ verlässlich aus einem String extrahieren – auch für Galerie-Pfade (`images/<ort>/p<id>.jpg`).
- Das Schema ist natürlich sortierbar und bleibt in der CSV-Datei leicht pflegbar.

## Alternativen
- **Separate Typ-Spalte in der CSV** – expliziter, erfordert aber Schemaänderung und Datenmigration.
- **Enum-Werte als Spaltenwert** – weniger kompakt, setzt Parser-Kenntnis voraus.
- **Datenbankgestützte Typisierung** – flexibler, aber inkompatibel mit dem CSV-Ansatz (ADR-003).

## Konsequenzen
### Positive
- CSV-Dateien bleiben kompakt – ein Feld kodiert Typ und Position gleichzeitig.
- Galerie-Pfade können direkt aus der ID abgeleitet werden (`images/<ort>/p<nr>.jpg`).
- Routing-Logik in `PrepareRouting` kann `u`- und `o`-Typen einfach herausfiltern.

### Negative / Risiken
- Das Format ist implizit; neue Entwickler müssen das Schema kennen.
- `IdParser` wirft `IllegalArgumentException`, wenn das Format nicht dem 3-Segment-Schema entspricht – fehlerhafte CSV-Zeilen können den ganzen Request abbrechen.
- Das Regex-Muster in `AnchorType` ist `.*-p.*` (enthält kein Wortgrenz-Matching) und könnte bei unerwarteten Ortsbezeichnungen mit `-p` im Namen fehlschlagen.

## Auswirkungen
Betrifft: `AnchorType`, `IdParser`, `PoiService`, `GalleryService`, `PrepareRouting`.  
Alle `*.csv`-Rohdaten.

## Datum
2026-03-04
