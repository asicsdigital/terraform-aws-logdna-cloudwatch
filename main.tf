locals {
  lambda_filename    = "${path.module}/files/logdna_cloudwatchlogs.zip" # in TF 0.12 path.module is relative https://github.com/hashicorp/terraform/issues/22708#issuecomment-528969322
  service_identifier = var.service_identifier
  logdna_tags        = join(",", concat([data.aws_region.current.name], var.logdna_tags))
  environment = {
    "LOGDNA_KEY"  = var.logdna_key
    "LOGDNA_TAGS" = local.logdna_tags
  }
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

data "aws_region" "current" {
}

resource "aws_iam_role" "lambda_execution_role" {
  name_prefix        = "lambda.${local.service_identifier}."
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "xray_wo" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_lambda_function" "logdna_cloudwatch" {
  description                    = "AWS Lambda for logging into LogDNA"
  filename                       = local.lambda_filename
  source_code_hash               = filebase64sha256(local.lambda_filename)
  function_name                  = local.service_identifier
  role                           = aws_iam_role.lambda_execution_role.arn
  handler                        = "index.handler"
  runtime                        = "nodejs10.x"
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.lambda_timeout

  tags = {
    Application = local.service_identifier
  }

  environment {
    variables = local.environment
  }
}
