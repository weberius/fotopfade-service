# Gherkin-Szenarien: GET /service/poi/{id}.geojson
#
# Endpunkt liefert alle sichtbaren POIs eines Kulturpfades
# als GeoJSON-FeatureCollection (Punkt-Geometrien).
# Sichtbar = Typ 'p' (Ankerpunkt), 'u' (unverankert) oder 'o' (außerhalb Route).

Feature: POI-Daten als GeoJSON abrufen

  Die REST-Ressource /service/poi/{id}.geojson stellt alle anzeigbaren
  Points of Interest eines Kulturpfades als GeoJSON-FeatureCollection bereit.
  Grundlage sind CSV-Daten mit dem Schema: id ; name ; lat ; lng ; zoom.

  Background:
    Given der Service läuft mit Spring Boot
    And für den Kulturpfad "frankenberg" existiert eine CSV-Datei im Classpath

  Scenario: POIs eines bekannten Kulturpfades abrufen
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then ist der HTTP-Statuscode 200
    And der Content-Type enthält "application/json"
    And die Antwort enthält ein JSON-Objekt mit dem Feld "type" = "FeatureCollection"
    And das Feld "features" ist eine nicht-leere Liste

  Scenario: Jedes Feature enthält die erwarteten Eigenschaften
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then enthält jedes Feature in "features" die Properties:
      | Property | Beschreibung                   |
      | id       | numerische ID des POI          |
      | nr       | laufende Nummer als String     |
      | name     | Bezeichnung des POI            |
      | nrname   | Kombination aus nr und name    |
      | type     | immer "poi"                    |
      | point    | Typ-Code: "p", "u" oder "o"   |
    And jedes Feature hat eine Geometrie vom Typ "Point"
    And die Koordinaten [lng, lat] sind gültige numerische Werte

  Scenario: Ankerpunkte (Typ 'p') sind enthalten
    Given die CSV enthält einen POI mit ID "frankenberg-p06-6"
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then enthält "features" ein Feature mit property "point" = "p"

  Scenario: Unverankerte Punkte (Typ 'u') sind enthalten
    Given die CSV enthält einen POI mit ID "frankenberg-u01-7"
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then enthält "features" ein Feature mit property "point" = "u"

  Scenario: Punkte außerhalb der Route (Typ 'o') sind enthalten
    Given die CSV enthält einen POI mit ID "frankenberg-o02-8"
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then enthält "features" ein Feature mit property "point" = "o"

  Scenario: Basisstationen (Typ 's') werden nicht angezeigt
    Given die CSV enthält einen POI mit ID "frankenberg-s01-9"
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then enthält kein Feature in "features" die property "point" = "s"

  Scenario: Nicht vorhandener Kulturpfad liefert leere FeatureCollection
    Given für den Kulturpfad "unbekannt-pfad" existiert keine CSV-Datei
    When ich GET /service/poi/unbekannt-pfad.geojson aufrufe
    Then ist der HTTP-Statuscode 200
    And das Feld "features" ist eine leere Liste

  Scenario: ID-Endung wird korrekt entfernt
    When ich GET /service/poi/frankenberg.geojson aufrufe
    Then wird intern die ID "frankenberg" (ohne ".geojson") verwendet
    And die Antwort enthält keine Fehlermeldung
