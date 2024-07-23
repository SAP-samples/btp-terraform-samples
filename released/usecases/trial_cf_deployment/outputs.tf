output "app_url" {
  value = "https://${cloudfoundry_route.helloterraform.url}"
}
