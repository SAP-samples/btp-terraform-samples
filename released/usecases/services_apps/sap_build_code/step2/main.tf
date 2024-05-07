resource "cloudfoundry_space" "space" {
  name      = "space"
  org       = "ca721b24-e24d-4171-83e1-1ef6bd836b38"
  allow_ssh = "true"
  labels    = { test : "pass", purpose : "prod" }
}