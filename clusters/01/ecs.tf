module "cluster" {
  source  = "code4romania/ecs-cluster/aws"
  version = "0.1.6"

  namespace             = local.namespace
  vpc_id                = module.networking.vpc_id
  ecs_subnets           = module.networking.private_subnet_ids
  security_groups       = [aws_security_group.ecs.id]
  default_instance_type = "m5a.large"
  instance_types = {
    "m5a.large" = ""
    "m5.large"  = ""
  }

  min_size                  = 2
  max_size                  = 4
  minimum_scaling_step_size = 1
  maximum_scaling_step_size = 1

  target_capacity                          = 100
  capacity_rebalance                       = true
  on_demand_base_capacity                  = 0 # could be set to 1 for stability. consider savings plan
  on_demand_percentage_above_base_capacity = 100
  ecs_cloudwatch_log_retention             = 30
  userdata_cloudwatch_log_retention        = 30

  spot_allocation_strategy = "price-capacity-optimized"
  spot_instance_pools      = 0

  service_discovery_domain = "${var.subdomain}.wfscoli.svc"
}

resource "aws_security_group" "ecs" {
  name        = "${local.namespace}-ecs"
  description = "Inbound Security Group attached to the ECS Service (${var.env})"
  vpc_id      = module.networking.vpc_id

  ingress {
    description     = "Load balancer traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    description = "Internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # ingress {
  #   description     = "Bastion access"
  #   from_port       = 0
  #   to_port         = 0
  #   protocol        = "-1"
  #   security_groups = [aws_security_group.bastion.id]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
