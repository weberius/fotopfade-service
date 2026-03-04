# Gherkin-Szenarien: Download-Menü (GPX-Export)
#
# Über ein Dropdown-Menü in der Navbar kann die berechnete Route
# als GPX-Datei heruntergeladen werden. Die URL wird aus dem
# aktuellen ?id-Parameter oder dem config-Standardwert gebildet.

Feature: GPX-Download über das Download-Menü

  Als Nutzer möchte ich die Wanderroute als GPX-Datei herunterladen,
  um sie auf einem GPS-Gerät oder in einer Navigations-App zu nutzen.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And der REST-Service ist erreichbar

  Scenario: Download-Dropdown zeigt einen GPX-Eintrag
    When der Nutzer auf das Download-Dropdown in der Navbar klickt
    Then ist mindestens ein Eintrag für den GPX-Download sichtbar

  Scenario: GPX-Download-URL basiert auf dem aktiven ?id-Parameter
    Given die Webapp wurde mit "?id=frankenberg" geöffnet
    When der Nutzer auf den GPX-Download-Link klickt
    Then wird die URL "service/gpx/frankenberg.gpx" aufgerufen

  Scenario: GPX-Download-URL basiert auf config.start.id, wenn kein ?id vorhanden
    Given die Webapp wurde ohne ?id-Parameter geöffnet
    And "config.start.id" ist "frankenberg"
    When der Nutzer auf den GPX-Download-Link klickt
    Then wird die URL "service/gpx/frankenberg.gpx" aufgerufen

  Scenario: Browser startet den Download der GPX-Datei
    When der Nutzer den GPX-Download auslöst
    Then liefert der Server HTTP 200 mit einer nicht-leeren GPX-Datei
    And der Browser bietet die Datei zum Speichern an (Dateiname: "frankenberg.gpx")

  Scenario: Download-Dropdown ist auf kleinen Bildschirmen ausgeblendet
    Given die Bildschirmbreite ist ≤ 767 px (xs-Breakpoint)
    When die Navbar gerendert wird
    Then ist das Download-Dropdown-Element mit der CSS-Klasse "hidden-xs" nicht sichtbar

  Scenario: Download-Dropdown ist auf größeren Bildschirmen sichtbar
    Given die Bildschirmbreite ist > 767 px
    When die Navbar gerendert wird
    Then ist das Download-Dropdown in der Navbar sichtbar und klickbar
