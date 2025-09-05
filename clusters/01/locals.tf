locals {
  namespace         = "wfscoli-${var.subdomain}-${var.env}"
  media_domain_name = "media.${aws_route53_zone.main.name}"

  image_tag = "1.11.2"

  services = [
    # {
    #   name = "school-name"
    #   hostname = "school-name.ro"
    # }
    {
      name = "gpp-sf-agnes"
    },
    {
      name = "sgn-balcescu-bacau"
    },
    {
      name = "gpp-sbs-12"
    },
    {
      name = "sg2-cernica-tanganu"
    },
    {
      name = "sg-dragomiresti"
    },
    {
      name = "gpp-pinochio"
    },
    {
      name = "sg18-galati"
    },
    {
      name = "sg-octavianvoicu-bacau"
    },
    {
      name = "lt-mihailsadoveanu-chisinau"
    },
    {
      name = "sg-petrucomarnescu-gh"
    },
  ]
}
