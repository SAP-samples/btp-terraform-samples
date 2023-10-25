output "api_url" {
  value = "https://api.cf.${replace(var.environment_label, "cf-", "")}.hana.ondemand.com"
}
