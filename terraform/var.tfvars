resource "random_string" "rnd" {
  length = 4
  special = false
  upper = false
}

variable "Suffix" {
  default = "${random_string.rnd.result}"
}

variable "RGName" {
  default = "AzureDevWorkshop${var.Suffix}"
}

variable "Location" {
  default = "germanywestcentral"
}

variable "WebAppPlanName" {
  default = "demoPlanDev${var.Suffix}"
}

variable "WebAppName" {
  default = "wrkshpwebfrontend${var.Suffix}"
}

variable "DataStorename" {
  default = "wrkshpdatastore${var.Suffix}"
}

variable "ImagesContainerName" {
  default = "images"
}

variable "FunctionStorage" {
  default = "wrkshpfunctionstore${var.Suffix}"
}

variable "FunctionName" {
  default = "wrkshptodofunction${var.Suffix}"
}

variable "KeyVaultName" {
  default = "wrkshpkeyvault${var.Suffix}"
}

variable "SecretName" {
  default = "StorageConnectionString"
}

variable "AppInsightsName" {
  default = "wrkshpmonitoring${var.Suffix}"
}

variable "WorkspaceName" {
  default = "wrkshpmonitoringworspace${var.Suffix}"
}

variable "RegistryName" {
  default = "myacr${var.Suffix}"
}

variable "ImageTag" {
  default = "frontend:v1"
}

variable "AKSName" {
  default = "myaks${var.Suffix}"
}