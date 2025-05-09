module "scoala-nr-1-test" {
  source  = "code4romania/ecs-service-wfscoli/aws"
  version = "0.1.0"

  name = "scoala-nr-1-test"

  common = {
    image_tag                     = "1.10.5"
    namespace                     = local.namespace
    env                           = var.env
    rds_secrets_arn               = aws_secretsmanager_secret.rds.arn
    create_database_function_name = aws_lambda_function.create_database.function_name
    subdomain                     = aws_route53_zone.main.name

    media = {
      s3_bucket_name = module.s3_media.bucket
      s3_bucket_arn  = module.s3_media.arn
      cloudfront_url = aws_cloudfront_distribution.media.domain_name
    }

    ecs_cluster = {
      cluster_name                   = module.ecs.cluster_name
      log_group_name                 = module.ecs.log_group_name
      service_discovery_namespace_id = module.ecs.service_discovery_namespace_id
      security_groups                = [aws_security_group.ecs.id]
      network_subnets                = module.networking.private_subnet_ids
    }
  }
}
