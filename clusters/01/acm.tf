# Cloudfront
resource "aws_acm_certificate" "media" {
  provider                  = aws.acm
  validation_method         = "DNS"
  domain_name               = aws_route53_zone.main.name
  subject_alternative_names = [local.media_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "media_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.media.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

# Load Balancer
resource "aws_acm_certificate" "lb" {
  validation_method = "DNS"
  domain_name       = aws_route53_zone.main.name
  subject_alternative_names = [
    "*.${aws_route53_zone.main.name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "lb_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.lb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}
