module "networking" {
  source  = "code4romania/networking/aws"
  version = "0.1.1"

  namespace = local.namespace
}
