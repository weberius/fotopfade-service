# EPIC-011-STORY-004-TASK-001: Fallback in PoiValuesRepository.java anpassen

## Zugehörige Story
EPIC-011-STORY-004: Java-Code bereinigen – Fallback in PoiValuesRepository anpassen

## Beschreibung
Den Hard-coded Fallback auf `muelheim.csv` in `PoiValuesRepository.java` entfernen und durch eine sinnvolle Fehlerbehandlung ersetzen.

### Aktueller Code (`src/main/java/de/illilli/fotopfade/repository/PoiValuesRepository.java`)

```java
public PoiValuesRepository(String id) {
    if (id == null || id.isEmpty()) {
        this.data = "/muelheim.csv";
    } else {
        this.data = "/" + id + ".csv";
    }
}
```

### Zielzustand (Option b – empfohlen: fail-fast)

```java
public PoiValuesRepository(String id) {
    if (id == null || id.isEmpty()) {
        throw new IllegalArgumentException("Route-ID darf nicht null oder leer sein");
    }
    this.data = "/" + id + ".csv";
}
```

Alternativ (Option a – fail-silent, leere Liste):

```java
public PoiValuesRepository(String id) {
    if (id == null || id.isEmpty()) {
        this.data = null;
    } else {
        this.data = "/" + id + ".csv";
    }
}
// ... find() prüft bereits: if (this.getClass().getResource(this.data) == null) return beans;
```

## Schritte
- [ ] Entscheidung zwischen Option (a) und Option (b) treffen (siehe STORY-004, offene Frage)
- [ ] `PoiValuesRepository.java` entsprechend anpassen
- [ ] Prüfen, ob bestehende Tests den Konstruktor mit `null`/leerem String aufrufen
- [ ] Ggf. betroffene Tests anpassen
- [ ] Build ausführen: `mvn compile`

## Ergebnis
`PoiValuesRepository.java` enthält keinen Hard-coded Verweis auf `muelheim` mehr. Der Konstruktor verhält sich bei fehlender ID klar definiert.

## Status
Todo

## Aufwand
S
