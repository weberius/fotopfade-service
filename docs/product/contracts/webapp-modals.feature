# Gherkin-Szenarien: Informationsmodals (Start, About, Feature)
#
# Die Webapp verwendet Bootstrap-3-Modals für verschiedene Informationsbereiche:
# - Start-Modal: Willkommenstext beim Seitenaufruf
# - About-Modal: Projektinformationen in Tabs (Über, Features, Links, Disclaimer)
# - Feature-Modal: POI-Detailbeschreibung beim Marker-Klick
# - Route-Modal: Streckentabelle (DataTables)
#
# Alle Inhalte werden per fetch aus locales/<namespace>/<sprache>/ geladen.

Feature: Informationsmodals

  Als Nutzer möchte ich kontextabhängige Informationen in übersichtlichen
  Dialogen abrufen können, ohne die Kartenseite zu verlassen.

  Background:
    Given die Webapp ist mit "?id=frankenberg" und Sprache "de" geöffnet

  # ---------------------------------------------------------------------------
  # START-MODAL
  # ---------------------------------------------------------------------------

  Scenario: Start-Modal erscheint automatisch nach dem Laden der Route
    When die Route erfolgreich geladen wurde
    Then öffnet sich das Modal "#startModal" automatisch
    And der Modal-Titel ist i18next.t('startModalTitle')
    And der Modal-Body enthält den per Markdown gerenderten Text aus "startModalBody.md"

  Scenario: Start-Modal schließt sich automatisch nach 30 Sekunden
    When das Start-Modal geöffnet ist
    And 30 Sekunden vergangen sind
    Then ist das Modal automatisch geschlossen

  Scenario: Start-Modal kann manuell mit "Schliessen" geschlossen werden
    Given das Start-Modal ist offen
    When der Nutzer auf die Schaltfläche "Schliessen" klickt
    Then schließt sich das Modal sofort

  Scenario: Start-Modal erneut öffnen über Navbar-Start-Button
    When der Nutzer auf das Start-Icon (▶) in der Navbar klickt
    Then öffnet sich das Start-Modal erneut
    And die Karte zoomt erneut auf die Routenausdehnung

  # ---------------------------------------------------------------------------
  # ABOUT-MODAL
  # ---------------------------------------------------------------------------

  Scenario: About-Modal über Navbar-Button öffnen
    When der Nutzer auf das About-Icon (?) in der Navbar klickt
    Then öffnet sich das Modal "#aboutModalDiv"
    And der Titel lautet i18next.t('welcomeModelTitle')

  Scenario: About-Modal enthält vier Tab-Reiter
    When das About-Modal geöffnet ist
    Then sind Tab-Reiter aus "locales/frankenberg/de/aboutTabsHeader.html" sichtbar
    And mindestens die Tabs "Erwartungen", "Über", "Features", "Links" und "Disclaimer" sind vorhanden

  Scenario: Jeder Tab zeigt seinen Markdown-Inhalt an
    When das About-Modal geöffnet ist
    Then lädt der Tab "Erwartungen" den Inhalt aus "expectModalLi.md"
    And der Tab "Über" lädt "aboutModalLi.md"
    And der Tab "Features" lädt "featuresModalLi.md"
    And der Tab "Links" lädt "linksModalLi.md"
    And der Tab "Disclaimer" lädt "disclaimerModalLi.md"
    And alle Markdown-Inhalte werden in HTML gerendert

  Scenario: About-Modal mit "Schliessen" schließen
    Given das About-Modal ist offen
    When der Nutzer auf "Schliessen" klickt
    Then schließt sich das Modal

  # ---------------------------------------------------------------------------
  # FEATURE-MODAL (POI-Detailinformation)
  # ---------------------------------------------------------------------------

  Scenario: Feature-Modal öffnet sich beim Klick auf einen POI-Marker
    When der Nutzer auf einen POI-Marker klickt
    Then öffnet sich das Modal "#featureModal"
    And der Titel zeigt den POI-Namen aus den GeoJSON-Properties

  Scenario: Feature-Modal zeigt Markdown-Beschreibung als HTML
    Given für POI Nummer 6 existiert "locales/frankenberg/de/p6.md"
    When der Nutzer den Marker von POI 6 anklickt
    Then enthält der Modal-Body HTML-Text aus dem gerendertem Markdown "p6.md"

  Scenario: Nach Schließen des Feature-Modals ist Sidebar-Hover wieder aktiv
    Given das Feature-Modal ist offen
    When der Nutzer das Modal schließt
    Then ist der Mouseover-Event-Listener der Sidebar wieder aktiv

  # ---------------------------------------------------------------------------
  # ATTRIBUTIONS-MODAL
  # ---------------------------------------------------------------------------

  Scenario: Attributions-Inhalt wird aus Locale geladen
    When die Karte geladen ist
    Then wird der Inhalt des Attributions-Bereichs aus "leaflet-control-attribution.html" gesetzt
    And der Inhalt ist sprachabhängig
