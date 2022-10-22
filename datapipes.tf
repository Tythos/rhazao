resource "azurerm_storage_share" "ss" {
  name                 = "${var.name}-ss"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 16
}

resource "azurerm_container_group" "rediser" {
  name                = "${var.name}-rediser"
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
    name   = "rediser"
    image  = "${azurerm_container_registry.acr.login_server}/rediser:latest"
    cpu    = "1.0"
    memory = "1.0"

    ports {
      port     = 6379
      protocol = "TCP"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      name                 = "${var.name}-rediser-state"
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.sa.name
      storage_account_key  = azurerm_storage_account.sa.primary_access_key
      share_name           = azurerm_storage_share.ss.name
    }
  }
}
