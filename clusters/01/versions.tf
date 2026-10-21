terraform {
  required_version = "~> 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95"
    }
  }

  cloud {
    hostname     = "terrakube-api.serval-mark.ts.net"
    organization = "code4romania"

    workspaces {
      project = "wfscoli"
    }
  }
}
