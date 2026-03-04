# Gherkin-Szenarien: Bildgalerie mit GLightbox
#
# Über den Galerie-Button in der Navbar öffnet sich eine Lightbox-Galerie
# mit allen Fotos des aktiven Kulturpfades. Bilddaten kommen vom
# REST-Service (/service/gallery/{id}.json).

Feature: Bildgalerie mit Lightbox

  Als Nutzer möchte ich alle Fotos eines Kulturpfades in einer
  Bildergalerie betrachten und durch sie navigieren können.

  Background:
    Given die Webapp ist mit "?id=frankenberg" geöffnet
    And der REST-Service liefert eine nicht-leere Galerie-Liste für "frankenberg"

  Scenario: Galerie-Daten werden beim Seitenstart geladen
    When die Seite geladen wird
    Then wird "/service/gallery/frankenberg.json" per fetch aufgerufen
    And die Bildliste wird als galleryItems-Array gespeichert

  Scenario: GLightbox-Instanz wird nach dem Laden der Daten initialisiert
    When die Galerie-JSON-Daten empfangen wurden
    Then ist die GLightbox-Instanz mit Touch-Navigation und Loop initialisiert
    And jedes Element enthält href, type "image" und title

  Scenario: Klick auf Galerie-Button öffnet die Lightbox
    When der Nutzer in der Navbar auf das Galerie-Icon klickt
    Then öffnet sich die GLightbox-Lightbox mit dem ersten Bild
    And die Lightbox überlagert die gesamte Seite

  Scenario: Navigation durch die Galerie mit Pfeiltasten
    Given die Lightbox ist geöffnet
    When der Nutzer die Pfeiltaste "Rechts" drückt
    Then wird das nächste Bild angezeigt
    When der Nutzer die Pfeiltaste "Links" drückt
    Then wird das vorherige Bild angezeigt

  Scenario: Navigation durch die Galerie mit Touch-Swipe
    Given die Lightbox ist auf einem Touch-Gerät geöffnet
    When der Nutzer nach links wischt
    Then wird das nächste Bild angezeigt
    When der Nutzer nach rechts wischt
    Then wird das vorherige Bild angezeigt

  Scenario: Galerie ist endlos geloopt (letztes Bild → erstes Bild)
    Given die Lightbox ist beim letzten Bild
    When der Nutzer die Pfeiltaste "Rechts" drückt
    Then wird das erste Bild der Galerie angezeigt

  Scenario: Jedes Bild zeigt seinen Titel
    When der Nutzer ein Bild in der Lightbox betrachtet
    Then ist der Titel des Bildes (POI-Name) als Bildunterschrift sichtbar

  Scenario: Lightbox schließen mit ESC-Taste
    Given die Lightbox ist geöffnet
    When der Nutzer die Escape-Taste drückt
    Then schließt sich die Lightbox
    And die Webapp-Karte ist wieder sichtbar

  Scenario: Galerie-URL enthält keinen ?id-Parameter – kein Absturz
    # Bekanntes Risiko (ADR-W07): fetch("service/gallery/null.json") bei fehlendem ?id
    Given die Webapp wird ohne ?id-Parameter geöffnet
    When die Seite geladen wird
    Then wird kein unkontrollierter Script-Fehler angezeigt

  Scenario: Galerie ist leer – Lightbox wird nicht geöffnet
    Given der REST-Service liefert eine leere Galerie-Liste "[]"
    When der Nutzer auf den Galerie-Button klickt
    Then öffnet sich keine Lightbox (galleryLightbox ist nicht initialisiert)
    And es erscheint kein Fehler
