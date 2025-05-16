locals {
  namespace         = "wfscoli-${var.subdomain}-${var.env}"
  media_domain_name = "media.${aws_route53_zone.main.name}"

  image_tag = "1.11.1"

  services = [
    {
      name = "scoala-nr-1-test"
      # hostname  =
    }
  ]
}
