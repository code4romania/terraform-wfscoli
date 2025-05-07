module "s3_media" {
  source  = "code4romania/s3/aws"
  version = "0.1.0"

  name              = local.namespace
  enable_versioning = var.env == "production"
  policy            = data.aws_iam_policy_document.s3_cloudfront_media.json
}

resource "aws_s3_bucket_cors_configuration" "s3_media" {
  bucket = module.s3_media.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 86400
  }
}

data "aws_iam_policy_document" "s3_cloudfront_media" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_media.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.media.arn]
    }
  }
}
