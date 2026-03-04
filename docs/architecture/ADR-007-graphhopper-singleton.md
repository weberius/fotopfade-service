# ADR-007: GraphHopper-Instanz als applikationsweiter Singleton

## Status
Accepted

## Kontext
Der Aufbau einer `GraphHopper`-Instanz aus einer OSM-PBF-Datei (Importierung, Aufbau der CH-Datenstruktur) ist ein sehr zeitintensiver Vorgang (mehrere Minuten bei großen Dateien). Wird er bei jeder Routing-Anfrage erneut ausgeführt, ist die Anwendung nicht betriebsfähig.

## Entscheidung
Die `GraphHopper`-Instanz wird in `RoutingService` als **`static`-Feld** gehalten:

```java
private static GraphHopper hopper;
```

Sie wird beim ersten Konstruktoraufruf initialisiert, wenn sie noch `null` ist. Alle nachfolgenden Instanzen von `RoutingService` teilen sich dieselbe `GraphHopper`-Instanz innerhalb der JVM-Lebensdauer.

## Begründung
- Der Graphaufbau (Import + CH-Preprocessing) ist nur einmalig notwendig; der Cache wird auf dem Dateisystem persistiert.
- Ein `static`-Singleton ist die einfachste Variante, die ohne Spring-Kontext (da `RoutingService` nicht als Spring-Bean verwaltet wird) funktioniert.
- Nach der Initialisierung sind GraphHopper-Anfragen thread-safe und sehr schnell.

## Alternativen
- **Spring `@Bean` / `@Component` mit Singleton-Scope** – eleganter im Spring-Kontext, erfordert aber die Umstellung von `RoutingService` auf eine Spring-verwaltete Bean.
- **Neu-Initialisierung bei jedem Request** – funktional korrekt, aber inakzeptabel langsam.
- **Separate Initialisierungs-Phase im Spring ApplicationContext** (`ApplicationRunner` / `CommandLineRunner`) – würde frühzeitiges Scheitern sichtbar machen und die Kopplung reduzieren.

## Konsequenzen
### Positive
- Einfache Implementierung ohne zusätzliche Spring-Konfiguration.
- Initialisierung erfolgt lazy beim ersten Request; der Startvorgang der Applikation wird nicht blockiert.

### Negative / Risiken
- `static`-Zustand erschwert Unit-Tests (kein einfaches Mocking/Reset zwischen Tests möglich).
- Thread-Safety beim parallelen ersten Zugriff ist nicht explizit abgesichert (kein `synchronized`-Block um die `null`-Prüfung) – unter hoher Last könnte mehrfach initialisiert werden.
- OSM-Datenverzeichnis ist im Konstruktor fest auf `"osm"` voreingestellt – der Wert aus `application.yaml` wird nicht per Injection genutzt.

## Auswirkungen
Betrifft: `RoutingService`, `BuildGraphHopperCache`, `PrepareRouting`.

## Datum
2026-03-04
