# Erste Schritte mit Terraform: Provider und Ressourcen

## Ziel

In dieser Aufgabe wird eine minimale Terraform-Konfiguration erstellt, die einen Provider und zwei Ressourcen definiert. Anschließend werden die ersten Schritte des Terraform Workflows (`terraform init`, `terraform plan`) durchgeführt.

## Voraussetzungen

- Terraform CLI ist installiert (`terraform version`) oder via 

```shell
choco install terraform
```
installieren.

- Docker ist installiert und läuft

```bash
docker version
docker login
```

## Verzeichnisstruktur

Lege ein neues Verzeichnis für die Konfiguration an, z.B. `terraform/first-steps/`. Die wichtigsten Dateien sind:

- `provider.tf`
- `main.tf`

## Inhalt von provider.tf

Definiert den Terraform-Block, den benötigten Provider und die Provider-Konfiguration:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}
```

## Inhalt von main.tf

Definiert ein Docker-Image und einen Container, der dieses Image verwendet:

```hcl
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}

resource "docker_container" "simple_nginx_container" {
  name  = "my-nginx-container"
  image = docker_image.nginx_image.name
  ports {
    internal = 80
    external = 8080
  }
}
```

## Wichtiger Hinweis für Docker Desktop

Damit die Verbindung zum Docker Daemon funktioniert, muss in Docker Desktop unter **Settings > General** die Option zum Exposen des Docker Daemons über TCP aktiviert werden (z.B. Port 2375). Ohne diese Einstellung kann Terraform nicht auf Docker zugreifen.

## Terraform Workflow: init und plan

1. **Initialisierung**

   Führe im Terminal im Projektverzeichnis aus:
   ```bash
   terraform init
   ```
   Damit wird das Arbeitsverzeichnis initialisiert und der Provider heruntergeladen.

2. **Planung**

   Führe anschließend aus:
   ```bash
   terraform plan
   ```
   Damit wird eine Vorschau der geplanten Änderungen angezeigt. Es sollten zwei Ressourcen zur Erstellung angezeigt werden: ein `docker_image` und ein `docker_container`.

## Nachweise

Im Ordner `screenshots/` befinden sich Nachweise (Screenshots), dass die Befehle `terraform init` und `terraform plan` erfolgreich ausgeführt wurden.

# Aufgabe: Terraform-Konfiguration mit Variablen und Outputs

In dieser Aufgabe wird eine Terraform-Konfiguration erstellt, die Variablen und Outputs nutzt. Ziel ist es, die Konfiguration flexibel und wiederverwendbar zu gestalten und den kompletten Terraform-Workflow (init, plan, apply, destroy) zu durchlaufen.

## Aufbau der Terraform-Dateien

- **provider.tf**: Definiert den Provider-Block für Docker.
- **variables.tf**: Enthält die Input-Variablen:
  - `container_name` (string, Default: "my-flex-nginx-container")
  - `external_port` (number, kein Default)
  - `nginx_html_content` (string, Default: "<h1>Hello from Terraform!</h1><p>Container: my-flex-nginx-container</p>")
- **main.tf**: Definiert die Ressource `docker_container` und nutzt die Variablen. Der HTML-Inhalt wird per `upload`-Block in die index.html im Container geschrieben.
- **outputs.tf**: Gibt die wichtigsten Werte als Outputs aus:
  - `container_name_output`
  - `container_external_port`
  - `html_content_used`
- **test.tfvars**: Beispiel für alternative Werte zur Variablenübergabe.

## Beispiel: main.tf (mit Variablen und Upload)

```hcl
resource "docker_container" "simple_nginx_container" {
  name  = var.container_name
  image = "nginx:latest"
  ports {
    internal = 80
    external = var.external_port
  }
  upload {
    content = var.nginx_html_content
    file    = "/usr/share/nginx/html/index.html"
  }
}
```

## Beispiel: variables.tf

```hcl
variable "container_name" {
  description = "Name des Docker-Containers."
  type        = string
  default     = "my-flex-nginx-container"
}

variable "external_port" {
  description = "Externer Port, auf dem der Container erreichbar ist."
  type        = number
}

variable "nginx_html_content" {
  description = "Inhalt der index.html, die im Container bereitgestellt wird."
  type        = string
  default     = "<h1>Hello from Terraform!</h1><p>Container: var.container_name</p>"
}
```

## Beispiel: outputs.tf

```hcl
output "container_name_output" {
  description = "Name des erstellten Docker-Containers."
  value       = var.container_name
}

output "container_external_port" {
  description = "Externer Port, auf dem der Container erreichbar ist."
  value       = var.external_port
}

output "html_content_used" {
  description = "Verwendeter HTML-Inhalt für die index.html im Container."
  value       = var.nginx_html_content
}
```

## Methoden zur Variablenübergabe

1. **Default-Werte**: In variables.tf definierte Defaults werden genutzt, wenn keine anderen Werte übergeben werden.
2. **.tfvars-Datei**: Mit einer Datei wie test.tfvars können Werte gebündelt übergeben werden:
   ```bash
   terraform apply -var-file="test.tfvars"
   ```
3. **CLI-Flag**: Einzelne Werte können direkt beim Befehl übergeben werden:
   ```bash
   terraform apply -var="container_name=my-cli-container" -var="external_port=8081"
   ```

Priorität: CLI-Flag > .tfvars-Datei > Default-Wert

## Kompletter Workflow

1. **Initialisierung**
   ```bash
   terraform init
   ```
2. **Plan anzeigen**
   ```bash
   terraform plan -var-file="test.tfvars"
   ```
3. **Ressourcen anwenden**
   ```bash
   terraform apply -var-file="test.tfvars"
   ```
4. **Outputs anzeigen**
   ```bash
   terraform output
   ```
5. **Ressourcen entfernen**
   ```bash
   terraform destroy -var-file="test.tfvars"
   ```

## Hinweise
- Die Datei terraform.tfstate speichert den aktuellen Zustand der Infrastruktur.
- Im Ordner `screenshots/` befinden sich Nachweise für die Ausführung der Befehle.
- Die Variable `nginx_html_content` wird beim Erstellen des Containers direkt in die index.html geschrieben.