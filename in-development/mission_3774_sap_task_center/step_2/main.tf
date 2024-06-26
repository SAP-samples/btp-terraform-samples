###############################################################################################
# Create the Cloud Foundry space
###############################################################################################
resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
   org  = var.cf_org_id
}

###############################################################################################
# assign user as space manager
###############################################################################################
resource "cloudfoundry_space_role" "cf_space_manager" {
  username = var.cf_space_manager
  type     = "space_manager"
  space    = cloudfoundry_space.space.id
  origin   = "sap.ids"
}


###############################################################################################
# assign user as space developer
###############################################################################################
resource "cloudfoundry_space_role" "cf_space_developer" {
  username = var.cf_space_developer
  type     = "space_developer"
  space    = cloudfoundry_space.space.id
}

###############################################################################################
# Create service instance for taskcenter (one-inbox-service)
###############################################################################################
data "cloudfoundry_service" "srvc_taskcenter" {
  name       = "one-inbox-service"
 # depends_on = [time_sleep.wait_a_few_seconds]
}

resource "cloudfoundry_service_instance" "si_taskcenter" {
  name         = "sap-taskcenter"
  type         = "managed"
  space        = cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.srvc_taskcenter.service_plans["standard"]
  depends_on   = [cloudfoundry_space_role.cf_space_manager, cloudfoundry_space_role.cf_space_developer]
  parameters = jsonencode({
	              "authorities": [],
                "defaultCollectionQueryFilter": "own"

  })
}

###############################################################################################
# Create service key
###############################################################################################
resource "random_id" "service_key_stc" {
  byte_length = 12
}
resource "cloudfoundry_service_credential_binding" "sap-taskcenter" {
  type             = "key"
  name             = join("_", ["defaultKey", random_id.service_key_stc.hex])
  service_instance = cloudfoundry_service_instance.si_taskcenter.id
}

resource "btp_subaccount_service_binding" "taskcenter" {
  subaccount_id       = var.subaccount_id
  service_instance_id = cloudfoundry_service_instance.si_taskcenter.id
  name                = join("_", ["defaultKey", random_id.service_key_stc.hex])
  depends_on          = [cloudfoundry_service_instance.si_taskcenter]
}

###############################################################################################
# Prepare and setup service: destination
###############################################################################################
# Entitle subaccount for usage of service destination
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = var.subaccount_id
  service_name  = "destination"
  plan_name     = "lite"
}

# Get serviceplan_id for stc-service with plan_name "default"
data "btp_subaccount_service_plan" "destination" {
  subaccount_id = var.subaccount_id
  offering_name = "destination"
  name          = "lite"
  depends_on    = [btp_subaccount_entitlement.destination]
}
# Create service instance
resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = var.subaccount_id
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  name           = "destination"
  depends_on     = [data.btp_subaccount_service_plan.destination]
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          # This is the destination to the cicd-service binding
          {
            Description                = "[Do not delete] SAP Task Center - Dummy destination"
            Type                       = "HTTP"
            clientId                   = "${jsondecode(btp_subaccount_service_binding.taskcenter.credentials)["uaa"]["clientid"]}"
            clientSecret               = "${jsondecode(btp_subaccount_service_binding.taskcenter.credentials)["uaa"]["clientsecret"]}"
            "HTML5.DynamicDestination" = true
            Authentication             = "OAuth2JWTBearer"
            Name                       = "stc-destination"
            tokenServiceURL            = "${jsondecode(btp_subaccount_service_binding.taskcenter.credentials)["uaa"]["url"]}"
            ProxyType                  = "Internet"
            URL                        = "${jsondecode(btp_subaccount_service_binding.taskcenter.credentials)["url"]}"
            tokenServiceURLType        = "Dedicated"
          }
        ]
      }
    }
  })
}