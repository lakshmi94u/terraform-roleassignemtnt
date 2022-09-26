# Get the current Subscription
data "azurerm_subscription" "current" {}

# Define the Role assignments.
# Module will loop through each of the defined assignments in the local block below. 
# Assigning the role defined in `role_definition_name` at the chosen scope, to the defined `principal_id`.
/*locals {
  sub_id = data.azurerm_subscription.current.id
  assignments = {
    customSub = {
      scope                = local.sub_id
      role_definition_name = "Contributor"
      principal_ids         = ["046deb99-650a-4308-8c05-1cb9a6e1f07f"]
    },
    assignCustomRole = {
      scope                = local.sub_id
      role_definition_name = "customreader"
      principal_ids        = ["a4b3d0be-4c0b-4e8f-9fc3-b7a333331762"]
    }
  }
}

#-----------


resource "azurerm_role_assignment" "role_assignment" {
    for_each = local.assignments
    
    scope                            = each.value.scope
    role_definition_name             = each.value.role_definition_name
    principal_ids                    = each.value.principal_ids
    #skip_service_principal_aad_check = var.skip_service_principal_aad_check
}
*/
locals {
  #rg_id                  = azurerm_resource_group.rg_role_assignment.id
  sub_id = data.azurerm_subscription.current.id
  Reader_principals       = ["a4b3d0be-4c0b-4e8f-9fc3-b7a333331762"]
  Contributor_principals = ["046deb99-650a-4308-8c05-1cb9a6e1f07f"]
}

resource "azurerm_role_assignment" "contributor" {
count = length(local.Contributor_principals)
  scope                = "/subscriptions/c8ab01f9-4309-4142-b9d5-8b5845e0bf35/resourceGroups/terraform-rg" #local.sub_id
  role_definition_name = "Contributor"
  principal_id         = local.Contributor_principals[count.index]
}

resource "azurerm_role_assignment" "reader" {
count = length(local.Reader_principals)
  scope                = "/subscriptions/c8ab01f9-4309-4142-b9d5-8b5845e0bf35/resourceGroups/terraform-rg" #local.sub_id
  role_definition_name = "Reader"
  principal_id         = local.Reader_principals[count.index]
}