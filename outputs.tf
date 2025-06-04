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
