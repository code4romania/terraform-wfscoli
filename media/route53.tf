data "aws_route53_zone" "main" {
  name = "wfscoli.ro"
}

# Cloudfront
resource "aws_route53_record" "media_ipv4" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.media_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.media.domain_name
    zone_id                = aws_cloudfront_distribution.media.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "media_ipv6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.media_domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.media.domain_name
    zone_id                = aws_cloudfront_distribution.media.hosted_zone_id
    evaluate_target_health = true
  }
}
