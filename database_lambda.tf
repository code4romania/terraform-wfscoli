data "archive_file" "lambda_create_database" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/create-db"
  output_path = "${path.module}/lambda/create-db.zip"
}

resource "aws_lambda_function" "create_database" {
  function_name    = "${local.namespace}-create-database"
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.lambda_role.arn
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
      DB_HOST    = "${aws_db_instance.main.address}"
      DB_PORT    = "${aws_db_instance.main.port}"
      DB_NAME    = "${aws_db_instance.main.username}"
      AWS_REGION = "${var.region}"
    }
  }
}

resource "aws_security_group" "lambda_create_database" {
  name        = "${local.namespace}-lambda-create-database"
  description = "Outbound security group attached to the create database lambda"
  vpc_id      = module.networking.vpc_id

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.networking.vpc_cidr_block]
  }
}
