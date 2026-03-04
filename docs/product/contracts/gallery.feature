# Gherkin-Szenarien: GET /service/gallery/{id}.json
#
# Endpunkt liefert die geordnete Liste der Galeriebilder eines Kulturpfades
# als JSON-Array. Jedes Element enthält den relativen Bild-Pfad und den Titel.
# Grundlage sind die CSV-Daten; nur sichtbare Punkte ('p', 'u', 'o') erhalten Bilder.

Feature: Galerie-Daten als JSON abrufen

  Die REST-Ressource /service/gallery/{id}.json liefert eine sortierte Liste
  von Bildreferenzen für alle anzeigbaren POIs eines Kulturpfades.
  Das Format ist ein JSON-Array von Objekten mit "href" (relativer Pfad)
  und "title" (POI-Name). Die href folgt dem Schema:
  "images/<id>/p<nr>.jpg"

  Background:
    Given der Service läuft mit Spring Boot
    And für den Kulturpfad "frankenberg" existiert eine CSV-Datei im Classpath
    And die CSV enthält POIs mit den Typen 'p', 'u' und 'o'

  Scenario: Galerie eines bekannten Kulturpfades abrufen
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then ist der HTTP-Statuscode 200
    And der Content-Type enthält "application/json"
    And die Antwort ist ein JSON-Array

  Scenario: Jedes Galerie-Element hat die erwarteten Felder
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then enthält jedes Element im Array die Felder:
      | Feld  | Typ    | Beschreibung                                   |
      | href  | String | Relativer Bildpfad: "images/<id>/p<nr>.jpg"    |
      | title | String | Name des zugehörigen POI                        |

  Scenario: Bildpfade folgen dem erwarteten Namensschema
    Given die CSV enthält einen POI mit ID "frankenberg-p06-6" und Name "Marktplatz"
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then enthält das Array ein Element mit href = "images/frankenberg/p6.jpg"
    And das Element hat title = "Marktplatz"

  Scenario: Nur sichtbare Punkte ('p', 'u', 'o') erscheinen in der Galerie
    Given die CSV enthält POIs der Typen 'p', 'u', 'o' und 's'
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then enthält das Array keine Einträge für POIs vom Typ 's'

  Scenario: Basisstationen ('s') sind nicht in der Galerie enthalten
    Given die CSV enthält einen POI mit ID "frankenberg-s01-9" und Name "Basis"
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then enthält kein Element im Array den title "Basis"

  Scenario: Nicht vorhandener Kulturpfad liefert leeres Array
    Given für den Kulturpfad "unbekannt-pfad" existiert keine CSV-Datei
    When ich GET /service/gallery/unbekannt-pfad.json aufrufe
    Then ist der HTTP-Statuscode 200
    And die Antwort ist ein leeres JSON-Array "[]"

  Scenario: ID-Endung wird korrekt entfernt
    When ich GET /service/gallery/frankenberg.json aufrufe
    Then wird intern die ID "frankenberg" (ohne ".json") verwendet
    And die href-Werte enthalten "images/frankenberg/" als Präfix
