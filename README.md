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