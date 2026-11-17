locals {
  namespace         = "wfscoli-${var.subdomain}-${var.env}"
  media_domain_name = "media.${aws_route53_zone.main.name}"
}
