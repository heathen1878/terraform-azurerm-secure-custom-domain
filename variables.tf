variable "custom_domain" {
  description = "A map of custom domains and their associated app service"
  type = map(object(
    {
      hostname            = string
      app_service_name    = string
      resource_group_name = string
    }
  ))
}