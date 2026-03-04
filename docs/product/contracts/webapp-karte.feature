# Gherkin-Szenarien: Interaktive Leaflet-Karte
#
# Die Karte ist das zentrale UI-Element. Sie zeigt POI-Marker,
# die berechnete Route und verschiedene Basiskarten an.
# Steuerelemente: Zoom, GPS-Ortung, Ebenenauswahl, Koordinatenanzeige.

Feature: Interaktive Leaflet-Karte

  Als Nutzer möchte ich eine interaktive Karte sehen,
  auf der ich navigieren und POIs sowie Routen entdecken kann.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And der REST-Service liefert POIs und Route für "frankenberg"

  Scenario: Karte wird beim Start initialisiert und auf die Route ausgerichtet
    When die Route erfolgreich geladen wurde
    Then ist die Leaflet-Karte sichtbar
    And die Kartenansicht ist auf den Bereich der Route zentriert (fitBounds)

  Scenario: Standard-Basiskarte ist CartoDB Light
    When die Karte geladen ist
    Then ist die aktive Basiskarte "CartoDB"
    And die Kacheln von "basemaps.cartocdn.com" werden geladen

  Scenario: Basiskarte auf OpenStreetMap wechseln
    When der Nutzer im Ebenenauswahl-Steuerelement "OSM" wählt
    Then werden OSM-Kacheln von "tile.openstreetmap.de" geladen
    And die CartoDB-Kacheln werden entfernt

  Scenario: Zoom-Steuerung ist sichtbar und funktionsfähig
    When die Karte geladen ist
    Then befindet sich das Zoom-Steuerelement unten rechts
    When der Nutzer auf "+" klickt
    Then erhöht sich der Zoom-Level um 1
    When der Nutzer auf "−" klickt
    Then verringert sich der Zoom-Level um 1

  Scenario: GPS-Ortungsschaltfläche ist vorhanden
    When die Karte geladen ist
    Then ist das Locate-Steuerelement unten rechts sichtbar
    When der Nutzer auf das Locate-Icon klickt
    Then wird der Browser nach GPS-Erlaubnis gefragt

  Scenario: Koordinaten werden bei Kartenklick angezeigt
    When der Nutzer auf eine beliebige Stelle der Karte klickt
    Then zeigt das Koordinaten-Steuerelement Breiten- und Längengrad an

  Scenario: Highlight-Markierung wird bei Kartenklick gelöscht
    Given ein POI-Marker ist hervorgehoben (blauer Kreis)
    When der Nutzer auf eine freie Kartenfläche klickt
    Then wird die Hervorhebung entfernt

  Scenario: Kartenansicht wird nach Fenstergrößenänderung neu berechnet
    When der Nutzer das Browserfenster in der Größe verändert
    Then passt Leaflet die Ebenenauswahl-Höhe an die Kartenhöhe an (sizeLayerControl)

  Scenario: Tooltip erscheint bei starkem Einzoomen automatisch
    When der Zoom-Level auf 18 oder höher gesetzt wird
    Then werden POI-Tooltips (Namen) automatisch geöffnet
    When der Zoom-Level unter 18 fällt
    Then werden die Tooltips automatisch geschlossen
