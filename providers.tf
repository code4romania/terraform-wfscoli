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
