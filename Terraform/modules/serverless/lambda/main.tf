# modules/serverless/lambda/main.tf

resource "aws_lambda_function" "this" {
  function_name = "${var.prefix_resource_name}-lambda-${var.name}-${var.stack_number}"
  description   = var.description
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  filename         = var.filename
  source_code_hash = var.source_code_hash

  environment {
    variables = var.environment
  }

  layers = var.layers

  tags = var.tags
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.prefix_resource_name}-lambda-${var.name}-${var.stack_number}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "custom_policy" {
  name = "${var.prefix_resource_name}-lambda-${var.name}-${var.stack_number}-policy"
  role = aws_iam_role.lambda_exec.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "iam:PassRole",
          "dynamodb:PutItem",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "dynamodb:UpdateItem",
          "ses:SendRawEmail",
          "ses:SendEmail",
          "kms:Decrypt",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
