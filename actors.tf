resource "azuread_application" "app" {
  display_name = "${var.name}-app"
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.app.application_id
}

resource "azuread_service_principal_password" "sp-key" {
  service_principal_id = azuread_service_principal.sp.object_id
}
