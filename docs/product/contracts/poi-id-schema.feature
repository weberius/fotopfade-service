# Gherkin-Szenarien: POI-ID-Schema und Typ-Klassifizierung
#
# Beschreibt das Verhalten der Klassen AnchorType und IdParser,
# die das ID-Schema "ort-typNr-laufnr" interpretieren.

Feature: POI-ID-Schema und Punkt-Typ-Klassifizierung

  Das ID-Schema eines POI lautet: "<ort>-<typ><nr>-<laufnr>"
  Der Typ-Code bestimmt die Behandlung des POI im System:
    'p' = Ankerpunkt (Teil der Route, Galerie, Karte)
    'u' = unverankert (Karte, Galerie, aber kein Routenpunkt)
    'o' = außerhalb Route (Karte, Galerie, aber kein Routenpunkt)
    's' = Basisstation (nicht angezeigt, nicht verrouted)

  Scenario Outline: Typ-Erkennung anhand der ID
    Given die POI-ID "<id>"
    Then ist isAnchor(<id>) = <isAnchor>
    And  isUnanchored(<id>) = <isUnanchored>
    And  isOutOfRoute(<id>) = <isOutOfRoute>
    And  isBase(<id>) = <isBase>

    Examples:
      | id                      | isAnchor | isUnanchored | isOutOfRoute | isBase |
      | frankenberg-p06-6       | true     | false        | false        | false  |
      | frankenberg-u01-7       | false    | true         | false        | false  |
      | frankenberg-o02-8       | false    | false        | true         | false  |
      | frankenberg-s01-9       | false    | false        | false        | true   |

  Scenario Outline: ID-Zerlegung durch IdParser
    Given die POI-ID "<id>"
    When IdParser die ID verarbeitet
    Then ist location = "<location>"
    And  id (numerisch) = <nr>
    And  point = "<point>"

    Examples:
      | id                  | location    | nr | point |
      | frankenberg-p06-6   | frankenberg |  6 | p     |
      | frankenberg-u01-7   | frankenberg |  1 | u     |
      | frankenberg-o02-8   | frankenberg |  2 | o     |
      | moers-p12-12        | moers       | 12 | p     |

  Scenario: Ungültige ID-Segmentanzahl wirft Exception
    Given die POI-ID "nicht-valide"
    When IdParser die ID verarbeitet
    Then wird eine IllegalArgumentException geworfen
    And die Meldung enthält "Ungültige ID"

  Scenario: Nicht-numerischer ID-Anteil wirft Exception
    Given die POI-ID "ort-pXYZ-1"
    When IdParser die ID verarbeitet
    Then wird eine IllegalArgumentException geworfen
    And die Meldung enthält "Zahlen konnten nicht gelesen werden"

  Scenario: Galerie-Bildpfad wird korrekt aus der ID abgeleitet
    Given die POI-ID "frankenberg-p06-6"
    When IdParser die ID verarbeitet
    Then ergibt sich der Bildpfad "images/frankenberg/p6.jpg"
