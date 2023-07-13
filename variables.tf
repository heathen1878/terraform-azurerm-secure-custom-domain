variable "custom_domain" {
  description = "A map of custom domains and their associated app service"
  type = map(object(
    {
      hostname            = string
      app_service_name    = string
      app_service_slot_id = string
      location            = string
      resource_group_name = string
      cert_key            = string
      deploy_slot         = bool
    }
  ))
}

variable "app_service_certificate" {
  description = "A map of certificates to pull from Key Vault"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    key_vault_certificate_id = string
    tags = map(any)
  }))
}