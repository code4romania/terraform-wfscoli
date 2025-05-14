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
