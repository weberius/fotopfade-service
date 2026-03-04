# Gherkin-Szenarien: GET /service/data/{id}.json
#
# Endpunkt liefert tabellarische Streckendaten eines Kulturpfades
# als JSON-Objekt mit dem Feld "data" (Array von Culturalpath-Objekten).
# Wird von DataTables im Frontend über ajax-Integration konsumiert.

Feature: Streckentabelle als JSON abrufen

  Die REST-Ressource /service/data/{id}.json liefert Routing-Zusammenfassungen
  für alle Streckenabschnitte eines Kulturpfades im DataTables-kompatiblen
  JSON-Format: { "data": [ { "id", "name", "time", "distance" }, ... ] }.
  Nur Ankerpunkte (Typ 'p') erzeugen Tabelleneinträge; Basisstationen,
  unverankerte und außer-Route-Punkte werden herausgefiltert.

  Background:
    Given der Service läuft mit Spring Boot
    And im Verzeichnis "osm/" befindet sich eine gültige .osm.pbf-Datei
    And für den Kulturpfad "frankenberg" existiert eine CSV-Datei im Classpath

  Scenario: Tabellendaten eines bekannten Kulturpfades abrufen
    When ich GET /service/data/frankenberg.json aufrufe
    Then ist der HTTP-Statuscode 200
    And der Content-Type enthält "application/json"
    And die Antwort enthält ein JSON-Objekt mit dem Feld "data"
    And "data" ist ein Array

  Scenario: Jeder Tabelleneintrag hat die erwarteten Felder
    When ich GET /service/data/frankenberg.json aufrufe
    Then enthält jedes Element in "data" die Felder:
      | Feld     | Typ    | Beschreibung                          |
      | id       | String | Bezeichner des Streckenabschnitts     |
      | name     | String | Name des Ziel-POI                     |
      | time     | String | Gehzeit in Minuten (z. B. "5 min")    |
      | distance | String | Entfernung in Metern (z. B. "350 m")  |

  Scenario: Anzahl der Tabelleneinträge entspricht den Ankerpunkten minus Basisstationen
    Given die CSV enthält 10 POIs vom Typ 'p' und 2 vom Typ 's'
    When ich GET /service/data/frankenberg.json aufrufe
    Then enthält "data" weniger Einträge als POIs vom Typ 'p' insgesamt

  Scenario: Basisstationen ('s') werden nicht in die Tabelle aufgenommen
    Given die CSV enthält einen POI mit ID "frankenberg-s01-0" (Typ 's')
    When ich GET /service/data/frankenberg.json aufrufe
    Then enthält kein Element in "data" den Namen dieses Basis-POI

  Scenario: Nicht vorhandener Kulturpfad liefert leere data-Liste
    Given für den Kulturpfad "unbekannt-pfad" existiert keine CSV-Datei
    When ich GET /service/data/unbekannt-pfad.json aufrufe
    Then ist der HTTP-Statuscode 200
    And "data" ist ein leeres Array

  Scenario: ID-Endung wird korrekt entfernt
    When ich GET /service/data/frankenberg.json aufrufe
    Then wird intern die ID "frankenberg" (ohne ".json") verwendet
    And die Antwort enthält keine Fehlermeldung

  Scenario: OSM-Routing nicht verfügbar – Fehler wird propagiert
    Given im Verzeichnis "osm/" liegt keine .osm.pbf-Datei
    When ich GET /service/data/frankenberg.json aufrufe
    Then antwortet der Service mit einem HTTP-Fehlercode (4xx oder 5xx)
