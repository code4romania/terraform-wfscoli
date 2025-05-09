module "wfservice" {
  source  = "code4romania/ecs-service-wfscoli/aws"
  version = "0.1.1"

  for_each = locals.services

  name     = each.name
  hostname = try(each.value.hostname, null)

  common = {
    image_tag                     = local.image_tag
    namespace                     = local.namespace
    env                           = var.env
    rds_secrets_arn               = aws_secretsmanager_secret.rds.arn
    create_database_function_name = aws_lambda_function.create_database.function_name
    subdomain                     = aws_route53_zone.main.name

    media = {
      s3_bucket_name = module.s3_media.bucket
      s3_bucket_arn  = module.s3_media.arn
      cloudfront_url = local.media_domain_name
    }

    ecs_cluster = {
      cluster_name                   = module.cluster.cluster_name
      log_group_name                 = module.cluster.log_group_name
      service_discovery_namespace_id = module.cluster.service_discovery_namespace_id
      security_groups                = [aws_security_group.ecs.id]
      network_subnets                = module.networking.private_subnet_ids
    }
  }
}
