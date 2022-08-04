provider "aws" {
  region = local.aws.location
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "google" {
}
