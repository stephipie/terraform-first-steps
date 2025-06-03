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