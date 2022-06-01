
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    external = {
      source = "hashicorp/external"
    }
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.0.0"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
