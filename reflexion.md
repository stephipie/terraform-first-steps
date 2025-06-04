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

# Reflexion Terraform Workflow (Variablen und Outputs)

**Was hat der Befehl terraform apply getan, als du ihn zum ersten Mal mit deiner initialen Konfiguration (ohne Variablen) ausgeführt hast?**

Terraform apply hat die im Code definierten Ressourcen (Docker-Image und Docker-Container) erstellt. Es wurde ein Nginx-Container mit festen Werten für Name und Port gestartet.

**Was ist mit dem Terraform State (terraform.tfstate) passiert, nachdem du terraform apply und terraform destroy ausgeführt hast?**

Nach terraform apply wurde der aktuelle Zustand der Infrastruktur in der Datei terraform.tfstate gespeichert. Nach terraform destroy wurden die Ressourcen gelöscht und der State entsprechend aktualisiert, sodass keine Ressourcen mehr verwaltet werden.

**Wie haben die Variablen (variable {}, var.) deine Konfiguration flexibler und wiederverwendbarer gemacht, verglichen mit der initialen Konfiguration (ohne Variablen)?**

Durch Variablen kann die Konfiguration leicht angepasst werden, ohne den Code zu ändern. Namen, Ports und Inhalte können für verschiedene Umgebungen wiederverwendet und angepasst werden.

**Auf welche drei Arten hast du Werte an deine Input Variablen übergeben? Beschreibe kurz die Methode und ihre Priorität.**

1. Standardwert in variables.tf (niedrigste Priorität)
2. Übergabe per .tfvars-Datei (z.B. test.tfvars)
3. Übergabe per CLI-Flag (z.B. -var 'name=value', höchste Priorität)

**Was zeigen die Outputs (output {}, terraform output) an, nachdem du apply ausgeführt hast? Wofür sind sie nützlich?**

Outputs zeigen die Werte der definierten Ausgaben, z.B. Containername, Port und HTML-Inhalt. Sie sind nützlich, um wichtige Informationen nach der Bereitstellung direkt anzuzeigen oder an andere Tools weiterzugeben.

**Wie hast du den Inhalt der Variable nginx_html_content in die index.html Datei im laufenden Docker Container bekommen? Welche Terraform-Funktion (Provisioner) wurde dafür genutzt?**

Der Inhalt wurde mit dem upload-Block innerhalb der docker_container-Ressource direkt in die index.html im Container geschrieben. Die upload-Funktion von Terraform wurde genutzt, um die Datei beim Erstellen des Containers zu platzieren. Ein Provisioner war dadurch nicht notwendig.

