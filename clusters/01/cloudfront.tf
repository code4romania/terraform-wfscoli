resource "aws_cloudfront_distribution" "media" {
  comment         = "Media for ${local.namespace}"
  price_class     = "PriceClass_100"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  aliases         = [local.media_domain_name]

  origin {
    domain_name              = module.s3_media.bucket_regional_domain_name
    origin_id                = module.s3_media.id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_media.id
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD", "OPTIONS"]
    target_origin_id           = module.s3_media.id
    viewer_protocol_policy     = "redirect-to-https"
    compress                   = true
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6" #Managed-CachingOptimized
    origin_request_policy_id   = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" #Managed-CORS-S3Origin
    response_headers_policy_id = "eaab4381-ed33-4a86-88ca-d9558dc6cd63" #Managed-CORS-with-preflight-and-SecurityHeadersPolicy
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.media.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_media" {
  name                              = "${local.namespace}-s3-always-signv4"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
