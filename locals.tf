locals {
  namespace         = "${var.subdomain}-wfscoli-${var.env}"
  image_tag         = "1.10.5"
  media_domain_name = "media.${aws_route53_zone.main.name}"

  services = [
    {
      name = "scoala-nr-1-test"
      # hostname  =
    }
  ]
}
