variable "service_name" {
  type = string
  description = "The name of the service"
}

variable "service_instance_name"{
  type = string
  description = "The name of the service instance"
}

variable "plan_name" {
  type = string
  description = "The name of the service plan"
}

variable "parameters" {
  type = string
  description = "The values for the service instance parameters (JSON string)"
}

variable "cf_space_id" {
  type = string
  description = "The ID of the Cloudfoundry space"
}
