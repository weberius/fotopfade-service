# Gherkin-Szenarien: Routen-Anzeige und Streckentabelle
#
# Die Route wird als schwarzer Linienzug auf der Karte angezeigt.
# Beim Klick auf die Navbar-Schaltfläche "Route" erscheint ein Modal
# mit einer DataTables-Tabelle der Streckenabschnitte.
# Beim Start wird automatisch ein Willkommens-Modal mit der Karte
# auf die Route ausgerichtet angezeigt.

Feature: Routen-Anzeige und Streckentabelle

  Als Nutzer möchte ich die Wanderroute auf der Karte sehen
  und Informationen über Entfernungen und Zeiten zwischen den
  Sehenswürdigkeiten abrufen können.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And der REST-Service liefert Routen-Daten für "frankenberg"

  Scenario: Route wird als schwarze Linie auf der Karte angezeigt
    When der Route-Layer erfolgreich von "/service/route/frankenberg.geojson" geladen wurde
    Then ist die Route als schwarzer, durchgehender Linienzug sichtbar
    And die Route-Linie ist nicht klickbar für den Nutzer gesperrt

  Scenario: Klick auf einen Routenabschnitt öffnet Distanz-Info-Modal
    When der Nutzer auf einen Abschnitt des Linienzugs klickt
    Then öffnet sich das Feature-Modal
    And der Titel lautet "Entfernung"
    And das Modal zeigt Entfernung (z. B. "350 m") und Gehzeit (z. B. "5 min")

  Scenario: Karte wird beim Start auf die Routenausdehnung gezoomt
    When die Route erfolgreich geladen wurde und gültige Bounds hat
    Then führt die Karte automatisch fitBounds auf die Route aus

  Scenario: Start-Modal erscheint automatisch nach dem Routenladen
    When die Route erfolgreich geladen wurde
    Then öffnet sich das Start-Modal mit dem Willkommenstext
    And das Modal zeigt den Inhalt aus "locales/frankenberg/de/startModalBody.md"
    And das Modal schließt sich automatisch nach 30 Sekunden

  Scenario: Start-Modal kann manuell über "Start"-Button in der Navbar geöffnet werden
    Given das Start-Modal wurde bereits automatisch geschlossen
    When der Nutzer in der Navbar auf das Start-Icon (▶) klickt
    Then öffnet sich das Start-Modal erneut
    And die Karte wird erneut auf die Route zentriert

  Scenario: Route kann über den Ebenenauswahl-Dialog aus- und eingeblendet werden
    When der Nutzer im Layercontrol "Route" deaktiviert
    Then verschwindet der Routenlinienzug von der Karte
    When der Nutzer "Route" wieder aktiviert
    Then erscheint der Linienzug erneut

  Scenario: Route-Modal mit Streckentabelle öffnen
    When der Nutzer in der Navbar auf "Route" klickt
    Then öffnet sich das Route-Modal
    And die Tabelle "#culturalpath" ist sichtbar
    And die Daten werden von "/service/data/frankenberg.json" geladen

  Scenario: Streckentabelle zeigt Name, Zeit und Entfernung je Abschnitt
    When das Route-Modal mit der DataTables-Tabelle geladen ist
    Then enthält jede Tabellenzeile die Spalten:
      | Spalte     | Beispielwert |
      | Name       | Rathaus      |
      | Zeit       | 5 min        |
      | Entfernung | 350 m        |

  Scenario: Streckentabelle hat keine Suche, kein Paging und keine Sortierung
    When das Route-Modal geöffnet ist
    Then gibt es kein Sucheingabefeld in der Tabelle
    And es gibt keine Seitenwechsel-Steuerung
    And es gibt keine klickbaren Spaltenköpfe zur Sortierung

  Scenario: Route nicht verfügbar – keine Fehlermeldung für den Nutzer
    Given der REST-Service ist nicht erreichbar
    When die Webapp geladen wird
    Then ist kein Script-Fehler sichtbar
    And die Karte wird geladen, auch wenn keine Route gezeichnet wird

  Scenario: Kein osm-Verzeichnis – Route-Modal zeigt leere Tabelle
    Given der REST-Service liefert für "/service/data/frankenberg.json" ein leeres "data"-Array
    When der Nutzer auf "Route" klickt
    Then öffnet sich das Route-Modal ohne Absturz
    And die Tabelle enthält keine Datenzeilen
