data "archive_file" "lambda_create_database" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/create-db"
  output_path = "${path.module}/../lambda/create-db.zip"
}

resource "aws_lambda_function" "create_database" {
  function_name    = "${local.namespace}-create-database"
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.lambda_create_database.arn
  filename         = data.archive_file.lambda_create_database.output_path
  source_code_hash = data.archive_file.lambda_create_database.output_base64sha256
  memory_size      = 128
  timeout          = 30

  vpc_config {
    subnet_ids         = module.networking.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_create_database.id]
  }

  environment {
    variables = {
      SECRET_NAME = "${aws_secretsmanager_secret.rds.name}"
    }
  }
}

resource "aws_iam_role" "lambda_create_database" {
  name               = "${local.namespace}-lambda-create-database"
  assume_role_policy = data.aws_iam_policy_document.lambda_create_database_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_create_database_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# VPC
resource "aws_iam_role_policy" "lambda_create_database_vpc" {
  name   = "vpc"
  role   = aws_iam_role.lambda_create_database.id
  policy = data.aws_iam_policy_document.lambda_create_database_vpc.json
}

data "aws_iam_policy_document" "lambda_create_database_vpc" {
  statement {
    // https://repost.aws/questions/QUbx7pdp-qTWWOiUb-WtEhFQ/resource-handler-returned-message-the-provided-execution-role-does-not-have-permissions-to-call-createnetworkinterface-on-ec2-service-lambda-status-code-400#AN5NU5MnorS1qSiMeGACMVlw
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
    ]

    resources = ["*"]
  }
}

# Secrets Manager
resource "aws_iam_role_policy" "lambda_create_database_secrets_manager" {
  name   = "rds-access"
  role   = aws_iam_role.lambda_create_database.id
  policy = data.aws_iam_policy_document.lambda_create_database_secrets_manager.json
}

data "aws_iam_policy_document" "lambda_create_database_secrets_manager" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.rds.arn,
    ]
  }
}

# Logs
resource "aws_iam_role_policy_attachment" "lambda_create_database_logs" {
  role       = aws_iam_role.lambda_create_database.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_security_group" "lambda_create_database" {
  name        = "${local.namespace}-lambda-create-database"
  description = "Outbound security group attached to the create database lambda"
  vpc_id      = module.networking.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.networking.vpc_cidr_block]
  }
}
