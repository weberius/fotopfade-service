# Gherkin-Szenarien: GET /service/route/{id}.geojson
#
# Endpunkt berechnet auf Basis von OSM-Daten und GraphHopper
# eine Fußgängerroute zwischen den Ankerpunkten eines Kulturpfades
# und liefert das Ergebnis als GeoJSON-FeatureCollection (LineStrings).

Feature: Routen-Daten als GeoJSON abrufen

  Die REST-Ressource /service/route/{id}.geojson liefert die berechnete
  Fußgängerroute eines Kulturpfades als GeoJSON-FeatureCollection.
  Jedes Feature repräsentiert einen Streckenabschnitt zwischen zwei
  aufeinanderfolgenden Ankerpunkten (Typ 'p'). Unverankerte und
  außer-Route-Punkte (Typ 'u', 'o') werden nicht berücksichtigt.
  Voraussetzung: eine .osm.pbf-Datei im osm/-Verzeichnis.

  Background:
    Given der Service läuft mit Spring Boot
    And im Verzeichnis "osm/" befindet sich eine gültige .osm.pbf-Datei
    And für den Kulturpfad "frankenberg" existiert eine CSV-Datei im Classpath
    And die CSV enthält mindestens zwei Ankerpunkte (Typ 'p')

  Scenario: Route eines bekannten Kulturpfades abrufen
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then ist der HTTP-Statuscode 200
    And der Content-Type enthält "application/json"
    And die Antwort enthält ein JSON-Objekt mit dem Feld "type" = "FeatureCollection"
    And das Feld "features" ist eine nicht-leere Liste

  Scenario: Jeder Streckenabschnitt ist ein LineString mit Properties
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then hat jedes Feature in "features" eine Geometrie vom Typ "LineString"
    And der LineString enthält mindestens zwei Koordinaten-Paare [lng, lat]
    And jedes Feature enthält die Properties:
      | Property | Format         | Beschreibung                            |
      | distance | "<n> m"        | Streckenlänge in Metern als String      |
      | time     | "<n> min"      | Gehzeit in Minuten als String           |
      | type     | "route"        | Fester Kennzeichner                     |

  Scenario: Nur Ankerpunkte ('p') fließen in die Routenberechnung ein
    Given die CSV enthält POIs der Typen 'p', 'u' und 'o'
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then entspricht die Anzahl der Features der Anzahl der Abschnitte zwischen 'p'-Punkten
    And kein 'u'- oder 'o'-Punkt ist Wegpunkt einer Route

  Scenario: Kein osm-Verzeichnis vorhanden – Service antwortet ohne Absturz
    Given im Verzeichnis "osm/" liegt keine .osm.pbf-Datei
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then antwortet der Service mit einem HTTP-Fehlercode (4xx oder 5xx)
    And die Fehlermeldung enthält einen Hinweis auf fehlende OSM-Daten

  Scenario: Kulturpfad-Koordinaten liegen außerhalb der OSM-Abdeckung
    Given die .osm.pbf-Datei deckt nur Region "Köln" ab
    And die CSV enthält Koordinaten aus "Australien"
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then antwortet der Service mit einem HTTP-Fehlercode
    And die Fehlermeldung enthält einen Hinweis auf fehlende Routenberechnung

  Scenario: Nicht vorhandener Kulturpfad – keine CSV-Datei
    Given für den Kulturpfad "unbekannt-pfad" existiert keine CSV-Datei
    When ich GET /service/route/unbekannt-pfad.geojson aufrufe
    Then ist der HTTP-Statuscode 200
    And das Feld "features" ist eine leere Liste

  Scenario: ID-Endung wird korrekt entfernt
    When ich GET /service/route/frankenberg.geojson aufrufe
    Then wird intern die ID "frankenberg" (ohne ".geojson") verwendet
    And die Antwort enthält keine Fehlermeldung
