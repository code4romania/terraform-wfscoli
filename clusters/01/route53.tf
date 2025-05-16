resource "aws_route53_zone" "main" {
  name = "${var.subdomain}.wfscoli.ro"
}

# Cloudfront
resource "aws_route53_record" "media_ipv4" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "media"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.media.domain_name
    zone_id                = aws_cloudfront_distribution.media.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "media_ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "media"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.media.domain_name
    zone_id                = aws_cloudfront_distribution.media.hosted_zone_id
    evaluate_target_health = true
  }
}

# Load Balancer
resource "aws_route53_record" "lb_ipv4" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "*"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "lb_ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "*"
  type    = "AAAA"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
