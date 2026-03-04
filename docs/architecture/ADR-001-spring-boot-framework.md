# ADR-001: Spring Boot als Application-Framework

## Status
Accepted

## Kontext
Der `fotopfade-service` ist ein REST-Backend, das geografische Daten (POIs, Routen, Galerien, GPX-Exporte) an eine JavaScript-Frontend-Applikation liefert. Es wird ein Framework benötigt, das:
- REST-Endpunkte einfach exponieren kann
- Produktionsreif und gut gewartet ist
- die Java-Ökosystem-Integration (Maven, Testing) unterstützt
- einen eingebetteten HTTP-Server mitbringt, um den Deployment-Aufwand gering zu halten

## Entscheidung
Der Service wird als **Spring Boot 3.x**-Anwendung (aktuell 3.5.0) mit `spring-boot-starter-hateoas` implementiert. Die Main-Klasse trägt `@SpringBootApplication`, REST-Endpunkte werden mit `@RestController` und `@GetMapping` deklariert.

## Begründung
- Spring Boot bietet einen embedded Tomcat und ermöglicht den Start als einfaches JAR (`java -jar fotopfade-*.jar`) – kein separater Application-Server nötig.
- `@RestController` und `@RequestMapping` reduzieren Boilerplate erheblich.
- Umfangreiche Community, Dokumentation und Kompatibilität mit GraphHopper, GeoTools und weiteren verwendeten Bibliotheken.
- Spring Boot 3.x setzt Java 21 voraus, das als LTS-Version gewählt wurde.

## Alternativen
- **Quarkus** – bessere Native-Image-Unterstützung, aber kleineres Ökosystem und höhere Einarbeitungszeit.
- **Micronaut** – ähnlich schlank, aber geringere Verbreitung in der Zielgruppe.
- **Plain Jakarta EE / WildFly** – zu viel Konfigurationsaufwand für einen schlanken Microservice.

## Konsequenzen
### Positive
- Einheitliches Konfigurations- und Build-Modell (`application.yaml`, Maven Spring Boot Plugin).
- Einfacher Start per `mvn spring-boot:run` bzw. als Fat-JAR.
- Automatische Bean-Verwaltung und Dependency Injection für zukünftige Erweiterungen nutzbar.

### Negative / Risiken
- Relativ großes Deployable (Fat-JAR); für den aktuellen Anwendungsfall vertretbar.
- Spring-Boot-Upgrades können Breaking Changes in abhängigen Bibliotheken (GeoTools, GraphHopper) erfordern.

## Auswirkungen
Betrifft alle Module des `fotopfade-service`:  
`Application.java`, `FotopfadeController`, alle Services und Repositories.

## Datum
2026-03-04
