variable "environment_label" {
  description = "The expected landscape (environment_label) of the cloudfoundry environment."
  type        = string

  validation {
    condition     = can(regexall("^cf-[a-z]{2,3}[0-9]{2}(-[0-9]{1,4})$", var.environment_label))
    error_message = "The environment_label seems to be wrong (cf-us10-001)"
  }
}
