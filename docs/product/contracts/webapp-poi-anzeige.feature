# Gherkin-Szenarien: POI-Anzeige auf der Karte und in der Sidebar
#
# POIs werden als Marker auf der Karte angezeigt und in der Sidebar
# als durchsuchbare Liste geführt. Ein Klick öffnet ein Modal mit
# der sprachabhängigen Beschreibung des POI.

Feature: POI-Anzeige auf Karte und in Sidebar

  Als Nutzer möchte ich Points of Interest auf der Karte und in einer
  Liste sehen und anklicken können, um mehr Informationen zu erhalten.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And der REST-Service liefert eine nicht-leere POI-FeatureCollection

  Scenario: POI-Marker werden nach dem Laden auf der Karte angezeigt
    When der POI-Layer erfolgreich geladen wurde
    Then sind POI-Marker auf der Karte sichtbar
    And die Marker befinden sich an den Koordinaten der CSV-Daten

  Scenario: POIs werden geclustert, wenn mehrere nah beieinander liegen
    When der Zoom-Level niedrig ist und mehrere POIs im Sichtbereich liegen
    Then werden nahegelegene POIs zu einem Cluster-Marker zusammengefasst
    When der Nutzer auf den Cluster klickt oder reinzoomt
    Then werden die einzelnen POIs sichtbar

  Scenario: Ein Klick auf einen POI-Marker öffnet das Feature-Modal
    When der Nutzer auf einen POI-Marker klickt
    Then öffnet sich das Feature-Modal
    And der Titel des Modals zeigt den Namen des POI
    And das Modal enthält den Beschreibungstext aus "locales/<namespace>/<sprache>/p<nr>.md"

  Scenario: Beschreibungstext wird als gerendertes HTML aus Markdown angezeigt
    Given für POI mit ID 1 existiert "locales/frankenberg/de/p1.md"
    When der Nutzer auf den Marker von POI 1 klickt
    Then enthält das Feature-Modal HTML (durch marked.js gerendert)
    And kein roher Markdown-Text ist sichtbar

  Scenario: Kein Beschreibungstext vorhanden – Modal öffnet trotzdem ohne Fehler
    Given für POI mit ID 99 existiert keine Markdown-Datei
    When der Nutzer auf den Marker von POI 99 klickt
    Then öffnet sich das Feature-Modal ohne Absturz
    And das Modal-Body ist leer (keine Fehlermeldung sichtbar)

  Scenario: POI-Klick hebt den POI auf der Karte hervor
    When der Nutzer auf einen POI-Marker klickt
    Then erscheint ein blauer Hervorhebungskreis an der Position des POI
    When das Feature-Modal geschlossen wird
    Then ist der Hover-Effekt der Sidebar wieder aktiv

  Scenario: Mouseover in der Sidebar hebt POI auf der Karte hervor
    Given die Sidebar ist sichtbar und enthält mindestens einen Eintrag
    When der Nutzer mit der Maus über eine Sidebar-Zeile fährt (kein Touch-Gerät)
    Then erscheint ein blauer Hervorhebungskreis an der Kartenposition des POI
    When der Mauszeiger die Zeile verlässt
    Then verschwindet die Hervorhebung

  Scenario: Klick auf eine Sidebar-Zeile zoomt auf den POI und öffnet das Modal
    When der Nutzer auf eine Zeile in der Sidebar klickt
    Then zoomt die Karte auf den zugehörigen POI (Zoom-Level 20)
    And das Feature-Modal öffnet sich für diesen POI

  Scenario: Auf Mobilgeräten wird die Sidebar nach POI-Klick ausgeblendet
    Given die Bildschirmbreite ist ≤ 767 px
    When der Nutzer auf eine Sidebar-Zeile klickt
    Then wird die Sidebar ausgeblendet
    And die Karte füllt den gesamten Bildschirm aus

  Scenario: Sidebar-Liste synchronisiert sich beim Kartenbewegen
    When der Nutzer die Kartenausschnitt verschiebt (moveend)
    Then zeigt die Sidebar nur POIs, die im aktuellen Kartenausschnitt liegen

  Scenario: POI-Layer kann über den Ebenenauswahl-Dialog ein- und ausgeblendet werden
    When der Nutzer im Layercontrol "Points Of Interest" deaktiviert
    Then verschwinden alle POI-Marker von der Karte
    And die Sidebar-Liste ist leer
    When der Nutzer "Points Of Interest" wieder aktiviert
    Then erscheinen die POI-Marker erneut
