# Gherkin-Szenarien: GET /service/gpx/{id}.gpx
#
# Endpunkt berechnet die Fußgängerroute und liefert sie als GPX-Datei
# zum Herunterladen (z. B. für GPS-Geräte oder externe Navigations-Apps).
# Die Datei wird intern auf dem Dateisystem zwischengespeichert.

Feature: Route als GPX-Datei herunterladen

  Die REST-Ressource /service/gpx/{id}.gpx berechnet die Fußgängerroute
  eines Kulturpfades via GraphHopper und stellt das Ergebnis als
  GPX-Datei (GPS Exchange Format) zum Download bereit.
  Der Response-Header enthält Content-Length;
  Content-Type ist nicht explizit gesetzt (Standard-Octet-Stream).

  Background:
    Given der Service läuft mit Spring Boot
    And im Verzeichnis "osm/" befindet sich eine gültige .osm.pbf-Datei
    And für den Kulturpfad "frankenberg" existiert eine CSV-Datei im Classpath
    And die CSV enthält mindestens zwei Ankerpunkte (Typ 'p')

  Scenario: GPX-Datei eines bekannten Kulturpfades herunterladen
    When ich GET /service/gpx/frankenberg.gpx aufrufe
    Then ist der HTTP-Statuscode 200
    And der Response-Body ist nicht leer
    And der Response-Header enthält "Content-Length" mit einem Wert > 0

  Scenario: GPX-Struktur enthält gültige Wegpunkte
    When ich GET /service/gpx/frankenberg.gpx aufrufe
    Then enthält der Response-Body valides XML mit dem Root-Element "<gpx"
    And das GPX enthält mindestens ein "<rte>" oder "<trk>"-Element
    And alle Wegpunkte besitzen gültige lat- und lon-Attribute

  Scenario: Alle berechneten Routenpunkte sind in der GPX-Datei enthalten
    Given die Routenberechnung liefert N Koordinatenpunkte
    When ich GET /service/gpx/frankenberg.gpx aufrufe
    Then enthält die GPX-Datei genau N Wegpunkte

  Scenario: Nicht vorhandener Kulturpfad – keine CSV-Datei
    Given für den Kulturpfad "unbekannt-pfad" existiert keine CSV-Datei
    When ich GET /service/gpx/unbekannt-pfad.gpx aufrufe
    Then antwortet der Service mit einem HTTP-Fehlercode (4xx oder 5xx)

  Scenario: OSM-Routing nicht verfügbar
    Given im Verzeichnis "osm/" liegt keine .osm.pbf-Datei
    When ich GET /service/gpx/frankenberg.gpx aufrufe
    Then antwortet der Service mit einem HTTP-Fehlercode (4xx oder 5xx)
    And die Fehlermeldung enthält einen Hinweis auf fehlende Routenberechnung

  Scenario: ID-Endung wird korrekt entfernt
    When ich GET /service/gpx/frankenberg.gpx aufrufe
    Then wird intern die ID "frankenberg" (ohne ".gpx") verwendet
    And die erzeugte Datei heißt "./frankenberg.gpx"

  Scenario: Parallele Anfragen für dieselbe ID (bekanntes Risiko)
    # Bekanntes Risiko (ADR-008): gleichzeitige Anfragen überschreiben die Datei
    When zwei gleichzeitige Anfragen GET /service/gpx/frankenberg.gpx gestellt werden
    Then liefert mindestens eine Anfrage eine vollständige GPX-Datei
    # Anmerkung: Korrektheit beider Antworten ist nicht garantiert (Race Condition)
