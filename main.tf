resource "local_file" "temp_html" {
  content  = "<h1>${var.nginx_html_content}</h1>"
  filename = "${path.module}/temp_index.html"
}

resource "docker_container" "simple_nginx_container" {
  name  = var.container_name
  image = "nginx:latest"
  ports {
    internal = 80
    external = var.external_port
  }  # Warte kurz, bis der Container gestartet ist
  provisioner "local-exec" {
    command = "docker cp ${local_file.temp_html.filename} ${self.name}:/usr/share/nginx/html/index.html"
  }
}