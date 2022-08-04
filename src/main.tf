terraform {
  cloud {
    organization = ""
    workspaces {
      name = ""
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.24.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.16.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=4.31.0"
    }
  }
}
