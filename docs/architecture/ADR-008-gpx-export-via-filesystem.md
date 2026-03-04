# ADR-008: GPX-Export über temporäre Filesystem-Datei

## Status
Accepted

## Kontext
Der Endpunkt `/service/gpx/{id}` soll eine GPX-Datei zurückgeben, die die berechnete Fußgängerroute enthält. Die Bibliothek `io.jenetics:jpx` erzeugt GPX-Daten als `GPX`-Objekt und schreibt diese über `GPX.write()` in eine Datei. Das Ergebnis muss als HTTP-Response-Body zurückgegeben werden.

## Entscheidung
Die GPX-Erzeugung in `RouteServiceForGPX` schreibt die Datei zunächst **auf das lokale Dateisystem** (Arbeitsverzeichnis: `./<id>.gpx`). Der Controller liest die Datei anschließend als `FileInputStream`, verpackt sie in eine `InputStreamResource` und liefert sie als `ResponseEntity` aus.

```java
new RouteServiceForGPX(id);           // schreibt <id>.gpx auf Disk
InputStream inputStream = new FileInputStream(new File("./" + id + ".gpx"));
```

## Begründung
- Die `jpx`-Bibliothek bietet primär dateibasiertes Schreiben (`GPX.write(gpx, path)`) an.
- Die Implementierung ist direkt und ohne zusätzliche Abstraktion verständlich.
- Für den aktuellen Einzelserver-Betrieb ist ein temporäres lokales File ausreichend.

## Alternativen
- **In-Memory via `ByteArrayOutputStream`** – `jpx` unterstützt auch Stream-basiertes Schreiben; würde Disk-I/O und Datei-Cleanup eliminieren.
- **Caching der GPX-Datei** – einmalige Berechnung und Wiederverwendung bei wiederholten Anfragen desselben Pfades.
- **Dediziertes temporäres Verzeichnis** – statt Arbeitsverzeichnis (`Files.createTempFile`) für bessere Isolation.

## Konsequenzen
### Positive
- Einfache, lineare Implementierung ohne Abstraktionsschichten.
- `Content-Length`-Header wird korrekt gesetzt (Dateigröße lesbar per `Files.size()`).

### Negative / Risiken
- Gleichzeitige Anfragen für dieselbe `id` können sich gegenseitig überschreiben (Race Condition), da der Dateiname deterministisch aus der ID gebildet wird.
- Die temporäre GPX-Datei wird nach der Auslieferung **nicht gelöscht** – Speicherleckage im Arbeitsverzeichnis.
- Bei Deployment in Umgebungen ohne Schreibrechte im Arbeitsverzeichnis (z. B. read-only Container-Filesystem) schlägt der Export fehl.
- Die Dateigröße wird nach dem Schreiben, aber vor dem Lesen ermittelt – ein gleichzeitiges Überschreiben würde zu inkonsistenter `Content-Length` führen.

## Auswirkungen
Betrifft: `RouteServiceForGPX`, `FotopfadeController` (`getGpx`-Methode).

## Datum
2026-03-04
