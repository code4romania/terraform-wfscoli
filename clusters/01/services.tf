module "wfservice" {
  source  = "code4romania/ecs-service-wfscoli/aws"
  version = "0.1.14"

  count    = length(local.services)
  name     = local.services[count.index].name
  hostname = try(local.services[count.index].hostname, null)

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

    service_discovery = {
      namespace_id = module.cluster.service_discovery_namespace_id
      arn          = module.cluster.service_discovery_arn
    }

    ecs_cluster = {
      name                           = module.cluster.cluster_name
      arn                            = module.cluster.cluster_arn
      log_group_name                 = module.cluster.log_group_name
      service_discovery_namespace_id = module.cluster.service_discovery_namespace_id
      vpc_id                         = module.networking.vpc_id
      security_groups                = [aws_security_group.ecs.id]
      network_subnets                = module.networking.private_subnet_ids
    }

    lb = {
      dns_name     = aws_lb.main.dns_name
      zone_id      = aws_lb.main.zone_id
      listener_arn = aws_lb_listener.https.arn
    }

    apigateway_vpc_link_id = aws_apigatewayv2_vpc_link.main.id
  }
}
