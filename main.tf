resource "azurerm_app_service_custom_hostname_binding" "secure_custom_domain" {
  for_each = var.custom_domain

  hostname            = each.value.hostname
  app_service_name    = each.value.app_service_name
  resource_group_name = each.value.resource_group_name

  provisioner "local-exec" {
    command = "sleep 240"
  }
}

resource "azurerm_app_service_certificate" "secure_custom_domain" {
  for_each = var.app_service_certificate

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  key_vault_secret_id = each.value.key_vault_certificate_id
  tags = each.value.tags
}

resource "azurerm_app_service_certificate_binding" "secure_custom_domain" {
  for_each = var.custom_domain

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.secure_custom_domain[each.key].id
  certificate_id      = azurerm_app_service_certificate.secure_custom_domain[each.value.cert_key].id
  ssl_state           = "SniEnabled"
}

resource "azurerm_app_service_slot_custom_hostname_binding" "secure_custom_domain_slot" {
  for_each = {
    for key, value in var.custom_domain : key => value if value.deploy_slot == true
  }

  app_service_slot_id = each.value.app_service_slot_id
  hostname            = format("staging-%s", each.value.hostname)
  ssl_state = "SniEnabled"
  thumbprint = azurerm_app_service_certificate.secure_custom_domain[each.value.cert_key].thumbprint

  provisioner "local-exec" {
    command = "sleep 180"
  }
}