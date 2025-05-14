terraform {
  required_version = "~> 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95"
    }
  }

  cloud {
    organization = "code4romania"

    workspaces {
      project = "wfscoli"
    }
  }
}
