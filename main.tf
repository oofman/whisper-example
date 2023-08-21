terraform {
  # Only Profider needed for now
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.68.0" # On the edge 3.70
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "whisper-rg" {
  name      = "whisper-example-rg"
  location  = var.location
  tags      = {
    env     = "whisper-example"
  }
}