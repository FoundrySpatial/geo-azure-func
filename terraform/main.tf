terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_integer" "id" {
  min = 10000
  max = 90000
}

resource "azurerm_resource_group" "geoAzureFunc_rg" {
  name = "geoAzureFunc_rg"
  location = "Canada Central"
}

resource "azurerm_storage_account" "geoazurefuncstorage" {
  name                     = "geoazurefuncstorage"
  resource_group_name      = "geoAzureFunc_rg"
  location                 = "Canada Central"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_service_plan" "geoAzureFunc_sp" {
  name                = "geoAzureFunc_sp"
  resource_group_name = "geoAzureFunc_rg"
  location            = "Canada Central"
  os_type             = "Linux"
  #Elastic and Consumption SKUs (Y1, EP1, EP2, and EP3) are for use with Function Apps.
  sku_name = "EP1"
}

resource "azurerm_linux_function_app" "geoazurefuncapp" {
  name                = "geoazurefuncapp"
  resource_group_name = "geoAzureFunc_rg"
  location            = "Canada Central"

  storage_account_name       = azurerm_storage_account.geoazurefuncstorage.name
  storage_account_access_key = azurerm_storage_account.geoazurefuncstorage.primary_access_key
  service_plan_id            = azurerm_service_plan.geoAzureFunc_sp.id

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  # identity {
  #   type = "SystemAssigned"
  # }

  site_config {
    container_registry_use_managed_identity = false

    application_stack {
      docker {
        registry_url = "foundrymainregistry.azurecr.io"
        image_name   = "geo-azure-func"
        image_tag    = "latest"
      }
    }
  }
}
