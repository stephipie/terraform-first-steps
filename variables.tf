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
