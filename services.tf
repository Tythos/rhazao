resource "azurerm_container_group" "mytest" {
  name                = "${var.name}-mytest"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_address_type     = "Public"
  os_type             = "Linux"

  image_registry_credential {
    username = azuread_service_principal.sp.application_id
    password = azuread_service_principal_password.sp-key.value
    server   = azurerm_container_registry.acr.login_server
  }

  container {
    name   = "mytest"
    image  = "${azurerm_container_registry.acr.login_server}/mytest:latest"
    cpu    = "1.0"
    memory = "1.0"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
