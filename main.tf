resource "docker_image" "nginx_image" {
  name = "nginx:latest"

}

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