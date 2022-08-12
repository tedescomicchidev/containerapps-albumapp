variable "environment" {
  default = "dev"
  description = ""
}

variable "resource_group_name" {
  default = "mitedesc-Tf-album-containerapps"
  description   = ""
}

variable "location" {
  default = "westeurope"
  description   = "Location of the resources."
}

variable "managed_environment_name" {
    default = "mitedesc-Tf-env-album-containerapps"
    description = ""
}

variable "api_name" {
    default = "album-api"
    description = "Backend API name"
}

variable "ui_name" {
    default = "album-ui"
    description = "FrontEnd name"
}

variable "github_user_name" {
    default = "tedescomicchidev"
    description = ""
}

variable "storage_account_name" {
    default = "mitedesctfalbumaca"
    description = "Store ACA and IaC data."
}

variable "storage_container_name" {
    default = "terraform-album-containerapps"
    description = "Store Terraform IaC data."
}

variable "azure_container_registry_prefix" {
    default = "mitedesctfacaalbums"
    description = "Name consists of prefix + GitHub username."
}

variable "azure_container_registry_username" {
    default = "acaalbumstedescomicchidev"
    description = ""
}

variable "azure_container_registry_pwd" {
    default = "OhBbZn3gHXpkuhZqc4awUs1QL32Y=utm"
    description = ""
}

variable "deploy_location" {
  type        = string
  default     = "eastus"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "rg_shared_name" {
  type        = string
  default     = "rg-shared-resources"
  description = "Name of the Resource group in which to deploy shared resources"
}