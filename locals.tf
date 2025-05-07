locals {
  namespace = "${var.subdomain}-wfscoli-${var.env}"

  availability_zone = data.aws_availability_zones.current.names[0]

  media_domain_name = "media.${aws_route53_zone.main.name}"
}
