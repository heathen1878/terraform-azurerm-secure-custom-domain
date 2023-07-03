resource "azurerm_app_service_custom_hostname_binding" "windows_web_apps" {
  for_each = var.custom_domain

  hostname            = each.value.hostname
  app_service_name    = each.value.app_service_name
  resource_group_name = each.value.resource_group_name

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "azurerm_app_service_managed_certificate" "windows_web_apps" {
  for_each = var.custom_domain

  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.windows_web_apps[each.key].id

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "azurerm_app_service_certificate_binding" "windows_web_apps" {
  for_each = var.custom_domain

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.windows_web_apps[each.key].id
  certificate_id      = azurerm_app_service_managed_certificate.windows_web_apps[each.key].id
  ssl_state           = "SniEnabled"

}