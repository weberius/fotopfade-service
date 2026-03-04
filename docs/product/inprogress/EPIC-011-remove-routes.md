# EPIC-011: Entfernung veralteter Routen-Konfigurationen

## Ziel

Entfernung von 11 veralteten Routen-Konfigurationen aus dem fotopfade-service. Alle zugehörigen Ressourcen (CSV-Dateien, Locales, Bilder) werden vollständig gelöscht. Referenzen im Java-Code werden bereinigt.

## Kontext

Im fotopfade-service existieren Routen-Konfigurationen, die nicht mehr aktiv genutzt werden oder in andere Projekte/Repositories überführt wurden. Diese veralteten Konfigurationen erhöhen die Codebasis unnötig, erschweren die Wartung und können zu Verwirrung führen. Die folgende Analyse zeigt den vollständigen Umfang der betroffenen Ressourcen:

| Route              | CSV | Locales (Sprachen)    | Images  |
|--------------------|-----|-----------------------|---------|
| 05315000-b03-t01   | ✓   | de, en                | –       |
| 05315000-b03-t02   | ✓   | de, en                | 9       |
| 05315000-b03-t03   | ✓   | de, en                | –       |
| 05315000-b03-t04   | ✓   | de, en                | 8       |
| 05315000-b03-t05   | ✓   | de, en, fr            | 9       |
| 05315000-b03-t06   | ✓   | de, en                | 9       |
| brunnentour        | ✓   | –                     | –       |
| frankenberg-all    | ✓   | –                     | –       |
| hannover-vonazu    | ✓   | de                    | 1       |
| koelnLindenthal1   | ✓   | de, en                | 16      |
| muelheim           | ✓   | –                     | –       |

## Abgrenzung

Was ist explizit **nicht** Teil dieses EPICs:

- Entfernung weiterer Routen (z. B. `frankenberg`, `fritzlar`, `korbach`, `moers`)
- Anpassung der Daten im `fotopfade`-Frontend-Repository (separater Scope)
- Aufbau neuer Routen-Konfigurationen
- Änderungen an der Datenbankschicht oder Liquibase-Skripten

## Besondere Aspekte / Risiken

### Java-Code: `PoiValuesRepository.java`

`muelheim.csv` wird in `PoiValuesRepository` als **Fallback-Default** verwendet, wenn keine Route-ID übergeben wird (Zeile 24):

```java
if (id == null || id.isEmpty()) {
    this.data = "/muelheim.csv";
}
```

Nach Entfernung von `muelheim.csv` muss entweder:
- a) der Default auf eine verbleibende Route umgestellt werden, oder
- b) der Fallback-Mechanismus entfernt und durch eine explizite Fehlerbehandlung ersetzt werden.

### Test-Ressourcen

Unter `src/test/resources/` existieren drei legacy-Dateien (`kulturpfad-muelheim.json`, `kulturpfad-muelheim-poi.json`, `kulturpfad-muelheim.csv`), die aktuell von keinem Test referenziert werden. Sie sollten im Rahmen dieses EPICs ebenfalls entfernt werden.

### hannover-vonazu: Locale-Querverweis

Die Datei `src/main/webapp/locales/hannover-vonazu/de/linksModalLi.md` enthält eine Referenz auf `06634005` (bereits entfernt in vorherigem Schritt). Kein Handlungsbedarf mehr, da der gesamte Locale-Ordner gelöscht wird.

### Kein Eintrag in `data.geojson`

Die zu entfernenden Routen sind nicht in `src/main/webapp/data/data.geojson` referenziert – kein Handlungsbedarf dort.

## Stories

- **EPIC-011-STORY-001** CSV-Dateien entfernen (11 Dateien in `src/main/resources/`)
- **EPIC-011-STORY-002** Locales entfernen (8 Verzeichnisse in `src/main/webapp/locales/`)
- **EPIC-011-STORY-003** Images entfernen (5 Verzeichnisse in `src/main/webapp/images/`)
- **EPIC-011-STORY-004** Java-Code bereinigen: Fallback in `PoiValuesRepository.java` anpassen
- **EPIC-011-STORY-005** Test-Ressourcen bereinigen: `kulturpfad-muelheim.*` entfernen
- **EPIC-011-STORY-006** Build-Verifikation und Tests (`mvn clean package`)

## Erfolgsdefinition (Definition of Done)

- Alle 11 CSV-Dateien aus `src/main/resources/` entfernt
- Alle zugehörigen Locales-Verzeichnisse entfernt
- Alle zugehörigen Image-Verzeichnisse entfernt
- `PoiValuesRepository.java` enthält keinen Hard-coded Verweis auf `muelheim.csv` mehr
- Legacy-Testressourcen `kulturpfad-muelheim.*` entfernt
- Build läuft erfolgreich durch (`mvn clean package`)
- Alle bestehenden Tests laufen erfolgreich durch
- Änderungen per Git committet

## Risiken / Offene Fragen

- **Fallback-Default in `PoiValuesRepository`**: Welche Route soll als neuer Default dienen, oder soll die Logik komplett entfernt werden?
- **Deployment**: Sind die zu entfernenden Routen aktuell in einer Produktivumgebung aktiv? Ggf. ist eine koordinierte Abschaltung notwendig.
- **Frontend-Abhängigkeiten**: Verweist das `fotopfade`-Repository (separates Frontend) auf diese Routen? Ggf. ist eine abgestimmte Bereinigung notwendig.

## Status

In Progress

## Datum

2026-03-04
