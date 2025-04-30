resource "aws_db_instance" "main" {
  identifier          = local.namespace
  instance_class      = "db.t4g.medium"
  publicly_accessible = false
  multi_az            = true
  deletion_protection = true
  monitoring_interval = 60

  availability_zone = local.availability_zone

  username = "postgres"
  password = random_password.database.result
  port     = 3306

  iam_database_authentication_enabled = true

  engine                      = "postgres"
  engine_version              = "17.4"
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true

  # storage
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # backup
  backup_retention_period   = 30
  backup_window             = "00:30-01:00"
  copy_tags_to_snapshot     = true
  skip_final_snapshot       = var.env != "production"
  final_snapshot_identifier = "${local.namespace}-final-snapshot"

  maintenance_window = "Tue:01:30-Tue:02:30"

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database.id]

  lifecycle {
    ignore_changes = [
      availability_zone,
    ]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.namespace}-db-private"
  subnet_ids = module.networking.private_subnet_ids
}

resource "aws_security_group" "database" {
  name        = "${local.namespace}-rds"
  description = "Inbound security group attached to the RDS instance"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.networking.vpc_cidr_block]
  }
}

resource "random_password" "database" {
  length  = 32
  special = false

  lifecycle {
    ignore_changes = [
      length,
      special
    ]
  }
}

resource "random_string" "database_secret_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = false

  lifecycle {
    ignore_changes = [
      length,
      special,
      upper,
      numeric,
    ]
  }
}

resource "aws_secretsmanager_secret" "rds" {
  name = "${local.namespace}-db_credentials-${random_string.database_secret_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    "engine"   = aws_db_instance.main.engine
    "database" = aws_db_instance.main.db_name
    "username" = aws_db_instance.main.username
    "password" = aws_db_instance.main.password
    "host"     = aws_db_instance.main.address
    "port"     = aws_db_instance.main.port
  })
}
