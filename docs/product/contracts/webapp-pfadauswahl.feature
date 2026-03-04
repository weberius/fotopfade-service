# Gherkin-Szenarien: Pfadauswahl und URL-Parameter
#
# Die Webapp zeigt genau einen Kulturpfad an. Die Auswahl erfolgt
# per URL-Parameter ?id=<namespace>. Fehlt dieser, greift der
# Default-Wert aus config.js (config.start.id).

Feature: Pfadauswahl per URL-Parameter

  Als Nutzer möchte ich einen bestimmten Kulturpfad über die URL aufrufen können,
  damit ich direkt den richtigen Pfad sehe und den Link teilen kann.

  Background:
    Given die Webapp ist geöffnet
    And der REST-Service ist erreichbar

  Scenario: Pfad über ?id-Parameter laden
    When ich die Seite mit "?id=frankenberg" aufrufe
    Then werden POIs und Route des Pfades "frankenberg" geladen
    And der Seitentitel lautet "Fotopfad Frankenberg (Eder)"
    And die Navbar-Brand zeigt "Frankenberg (Eder)"

  Scenario: Ohne ?id-Parameter wird der Standardpfad geladen
    Given in config.js ist "config.start.id" = "frankenberg"
    When ich die Seite ohne ?id-Parameter aufrufe
    Then werden POIs und Route des Pfades "frankenberg" geladen

  Scenario: Pfad per ?id-Parameter überschreibt den Standardpfad
    Given in config.js ist "config.start.id" = "frankenberg"
    When ich die Seite mit "?id=moers" aufrufe
    Then werden POIs und Route des Pfades "moers" geladen
    And nicht die Daten des Standardpfades "frankenberg"

  Scenario: Ungültige ?id liefert leere Karte ohne Absturz
    When ich die Seite mit "?id=unbekannt-pfad" aufrufe
    Then wird kein Script-Fehler ausgelöst
    And die Karte ist sichtbar
    And es werden keine POI-Marker angezeigt
    And es wird keine Route angezeigt

  Scenario: Sprache über ?lng-Parameter erzwingen
    When ich die Seite mit "?id=frankenberg&lng=en" aufrufe
    Then verwendet i18next die Sprache "en"
    And die Navigationselemente sind auf Englisch

  Scenario: Link mit Pfad und Sprache ist vollständig teilbar
    When ich die URL "index.html?id=moers&lng=de" aufrufe
    Then laden POIs und Route des Pfades "moers"
    And i18next verwendet die Sprache "de"
