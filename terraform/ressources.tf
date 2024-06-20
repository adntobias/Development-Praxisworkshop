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
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "DevWorkshop" {
  name     = "AzureDevWorkshopTerraF"
  location = "germanywestcentral"
}

resource "azurerm_storage_account" "DataStore" {
  name                     = "wrkshpdatastoreTF"
  resource_group_name      = "AzureDevWorkshopTerraF"
  location                 = "germanywestcentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "FunctionStore" {
  name                     = "wrkshpdatastoreTF"
  resource_group_name      = "AzureDevWorkshopTerraF"
  location                 = "germanywestcentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "DataStoreContainer" {
  name                  = "images"
  storage_account_name  = "wrkshpdatastoreTF"
  container_access_type = "blob"
}

resource "azurerm_application_insights" "AppInsights" {
  name                = "wrkshpmonitoringTF"
  location            = "germanywestcentral"
  resource_group_name = "AzureDevWorkshopTerraF"
  application_type    = "web"
}

resource "azurerm_app_service_plan" "FrontendPlan" {
  name                = "demoPlanDevTF"
  location            = "germanywestcentral"
  resource_group_name = "AzureDevWorkshopTerraF"
  kind                = "App"
  
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "FunctionPlan" {
  name                = "demoPlanDevFunctionTF"
  location            = "germanywestcentral"
  resource_group_name = "AzureDevWorkshopTerraF"
  kind                = "FunctionApp"
  
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_key_vault" "KVault" {
  name                = "wrkshpkeyvaultTF"
  location            = "germanywestcentral"
  resource_group_name = "AzureDevWorkshopTerraF"
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  access_policy = [ {
    object_id = azurerm_linux_function_app.WorkerFunction.id
    secret_permissions = [ "get" ]
  } ]
}

resource "azurerm_linux_function_app" "WorkerFunction" {
  name                      = "wrkshptodofunctionTF"
  resource_group_name       = "AzureDevWorkshopTerraF"
  location                  = "germanywestcentral"
  storage_account_name      = azurerm_storage_account.FunctionStore.name
  #storage_connection_string = azurerm_storage_account.FunctionStore.primary_connection_string
  service_plan_id           = azurerm_app_service_plan.FunctionPlan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "STORAGE_NAME" = "wrkshpdatastoreTF"
    "STORAGE_KEY" = "${azurerm_storage_account.DataStore.primary_access_key}"
    "STORAGE_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=https://${azurerm_key_vault.KVault.name}.vault.azure.net/secrets/StorageConnectionString)"
    "TABLE_PARTITION_KEY" = "TODO"
  }

  site_config {
    always_on = true
  }
}

resource "azurerm_windows_web_app" "FrontendWeb" {
  name                = "wrkshpwebfrontendTF"
  location            = "germanywestcentral"
  resource_group_name = "AzureDevWorkshopTerraF"
  service_plan_id     = azurerm_app_service_plan.FrontendPlan.id
  
  app_settings = {
    "Function:FunctionUri"                      = "${azurerm_linux_function_app.WorkerFunction.FunctionUri}/api/"
    "Function:DefaultHostKey"                   = "${azurerm_linux_function_app.WorkerFunction.DefaultHostKey}"
    "StorageAccount:StorageConnectionString"    = "${azurerm_storage_account.DataStore.primary_connection_string}"
    "StorageAccount:TablePartitionKey"          = "TODO"
    "ApplicationInsights:InstrumentationKey"    = "${azurerm_application_insights.AppInsights.InstrumentationKey}"
    "Authentication:Instance"                   = "https://login.microsoftonline.com/"
    "Authentication:Domain"                     = "TBD"
    "Authentication:ClientId"                   = "TBD"
    "Authentication:TenantId"                   = "${data.current.tenant_id}"
    "Authentication:ClientSecret"               = "TBD"
    "Authentication:ClientCapabilities"         = "[ \"cp1\" ]"
    "DownstreamApi:Scopes"                      = "user.read"
    "DownstreamApi:BaseUrl"                     = "https://graph.microsoft.com/v1.0"
  }

  site_config {
    always_on = true
  }
}

resource "azurerm_key_vault_secret" "SecretConnString" {
  name          = "StorageConnectionString"
  value         = azurerm_storage_account.DataStore.primary_connection_string
  key_vault_id  = azurerm_key_vault.KVault.id
}
