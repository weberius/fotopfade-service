# Gherkin-Szenarien: Mehrsprachigkeit mit i18next
#
# Die Webapp erkennt die Browsersprache automatisch und unterstützt
# manuelle Sprachumschaltung über die Navbar. Fehlende Übersetzungen
# fallen auf Deutsch zurück (fallbackLng: 'de').

Feature: Mehrsprachigkeit und Sprachumschaltung

  Als Nutzer möchte ich die Webapp in meiner Sprache lesen können
  und die Sprache jederzeit manuell wechseln können.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And für "frankenberg" gibt es Übersetzungen in "de" und "en"

  Scenario: Sprache wird automatisch aus dem Browser erkannt
    Given der Browser ist auf Deutsch eingestellt
    When die Seite geladen wird
    Then verwendet i18next die Sprache "de"
    And die Navbar zeigt "Sehenswürdigkeiten" für den POI-Menüpunkt

  Scenario: Englische Browsersprache wird erkannt und angewendet
    Given der Browser ist auf Englisch eingestellt
    When die Seite geladen wird
    Then verwendet i18next die Sprache "en"
    And die Navbar zeigt den englischen Begriff für den POI-Menüpunkt

  Scenario: Sprache per ?lng-Parameter erzwingen überschreibt Browser-Einstellung
    Given der Browser ist auf Deutsch eingestellt
    When ich die Seite mit "?lng=en" aufrufe
    Then verwendet i18next die Sprache "en"
    And nicht die Browser-Sprache

  Scenario: Fehlende Übersetzung fällt auf Deutsch zurück
    Given für "frankenberg" existiert keine Übersetzung für Sprache "ja"
    When i18next die Sprache "ja" versucht zu verwenden
    Then fällt i18next auf "de" zurück (fallbackLng)
    And die Oberflächentexte werden auf Deutsch angezeigt

  Scenario: Sprachselektor in der Navbar zeigt verfügbare Sprachen
    When die Seite geladen ist
    Then enthält das Dropdown-Menü "Sprache" alle in "properties.json languages" definierten Sprachen
    And die aktuell aktive Sprache ist kursiv dargestellt

  Scenario: Sprachumschaltung über den Sprachselektor
    Given die aktive Sprache ist "de"
    When der Nutzer im Sprachselektor "english" wählt
    Then ruft i18next changeLanguage("en") auf
    And alle UI-Elemente werden ohne Seitenreload aktualisiert
    And der Seitentitel ändert sich auf den englischen Wert aus properties.json

  Scenario: Nach der Sprachumschaltung werden neue Locales-Dateien geladen
    When der Nutzer die Sprache auf "en" wechselt
    Then werden POI-Beschreibungen aus "locales/frankenberg/en/p<nr>.md" geladen
    And Modal-Inhalte aus "locales/frankenberg/en/*.md" werden neu eingesetzt

  Scenario: Alle UI-Texte werden nach dem Laden aus i18next-Übersetzungen gesetzt
    When die Seite vollständig geladen ist
    Then ist document.title = i18next.t('title')
    And navbar-brand = i18next.t('brand')
    And der "Route"-Menüpunkt = i18next.t('route')
    And der "Galerie"-Menüpunkt = i18next.t('gallerySelectorSpan') bw. t('gallery')
    And der "About"-Menüpunkt = i18next.t('about')

  Scenario: Sprachcode wird für nachfolgende fetch-Aufrufe gespeichert
    When i18next erfolgreich initialisiert wurde
    Then ist die Variable "languageCode" mit dem erkannten Sprachkürzel befüllt
    And wird beim Laden von Locale-Dateien per fetch verwendet
