module "networking" {
  source  = "code4romania/networking/aws"
  version = "0.1.1"

  namespace = local.namespace
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${local.namespace}-vpc-link"
  security_group_ids = [aws_security_group.gateway_vpc_link.id]
  subnet_ids         = module.networking.private_subnet_ids
}

resource "aws_security_group" "gateway_vpc_link" {
  name        = "${local.namespace}-gateway-vpc-link"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
}

resource "aws_security_group_rule" "allow_vpclink_to_ecs" {
  description              = "VPC link traffic"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.gateway_vpc_link.id
}
