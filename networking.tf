module "networking" {
  source  = "code4romania/networking/aws"
  version = "0.1.0"

  namespace = local.namespace
}
