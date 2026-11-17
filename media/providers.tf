terraform {
  required_version = "~> 1.17"

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
      name = "wfscoli-media"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      app     = "wfscoli"
      cluster = var.subdomain
      env     = var.env
    }
  }
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"

  default_tags {
    tags = {
      app     = "wfscoli"
      cluster = var.subdomain
      env     = var.env
    }
  }
}
