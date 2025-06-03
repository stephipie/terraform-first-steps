# Terraform Reflexion – Erste Schritte mit Provider und Ressourcen

## 1. Was ist die Rolle des `provider` Blocks in deiner Konfiguration?

Der `provider` Block legt fest, mit welcher Infrastrukturplattform Terraform kommunizieren soll – in meinem Fall mit Docker. Er enthält die Konfiguration, wie Terraform auf den Docker-Daemon zugreift (z. B. über einen Unix-Socket).

## 2. Warum ist er notwendig?

Ohne einen `provider` weiß Terraform nicht, **welche Art von Ressourcen** verwaltet werden sollen und **wie** es mit der Zielplattform kommuniziert. Der Provider ist die Schnittstelle zur realen Infrastruktur (hier: Docker).

## 3. Was ist die Rolle des `resource` Blocks?

Ein `resource` Block beschreibt **eine konkrete Komponente** der Infrastruktur, die Terraform verwalten soll – z. B. ein Docker-Image oder ein Container.

## 4. Was repräsentiert er im Vergleich zu einem `provider`?

Der `provider` ist **die Verbindung zur Plattform**, während eine `resource` eine **spezifische Einheit innerhalb dieser Plattform** ist.

**Beispiel:**
- `provider "docker"` = "Ich spreche mit Docker"
- `resource "docker_container"` = "Ich will einen Container auf Docker erstellen"

## 5. Wie hast du in deiner Konfiguration eine implizite Abhängigkeit zwischen der `docker_container` Ressource und der `docker_image` Ressource erstellt?

Ich habe im `docker_container` Block das Attribut `image` auf `docker_image.nginx_image.latest` gesetzt. Dadurch weiß Terraform, dass der Container **erst erstellt werden kann, nachdem** das Image vorhanden ist.

## 6. Warum ist es wichtig, dass Terraform diese Abhängigkeit versteht?

Damit Terraform die Ressourcen **in der richtigen Reihenfolge** erstellt. Ohne die Abhängigkeit würde Terraform eventuell versuchen, den Container zu starten, bevor das Image bereitsteht – das würde zu einem Fehler führen.

## 7. Was genau bewirkt der Befehl `terraform init`, wenn du ihn zum ersten Mal in einem Verzeichnis ausführst?

`terraform init` lädt die benötigten Provider (z. B. `kreuzwerker/docker`) herunter und initialisiert das Arbeitsverzeichnis. Es bereitet die Konfiguration vor, sodass Terraform Befehle wie `plan` oder `apply` ausführen kann.

## 8. Was genau zeigt der Output von `terraform plan` an?

`terraform plan` zeigt eine **Vorschau der Änderungen**, die Terraform ausführen würde, um den aktuellen Zustand an die Konfiguration anzupassen.

## 9. Welche Informationen liefert er, bevor du die Infrastruktur tatsächlich erstellst?

Der Plan zeigt:
- Welche Ressourcen erstellt, geändert oder gelöscht werden (`+`, `-`, `~`)
- Welche Attribute die Ressourcen haben werden (z. B. Name, Image)
- Ob Abhängigkeiten korrekt erkannt wurden

So kann man sicher prüfen, ob alles wie gewünscht erstellt wird – **ohne schon etwas zu verändern**.

