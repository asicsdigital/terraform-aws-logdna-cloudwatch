data "http" "logdna_cloudwatch" {
  url = "${var.url}"
}

data "archive_file" "logdna_cloudwatch" {
  type        = "zip"
  output_path = "${local.output_file}"

  source {
    filename = "logdna_cloudwatch.py"
    content  = "${data.http.logdna_cloudwatch.body}"
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

locals {
  output_file    = "${path.module}/files/lambda/package.zip"
  service_identifier = "${var.service_identifier}"
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda.${local.service_identifier}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_execution_basic" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "xray_wo" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_lambda_function" "logdna_cloudwatch" {
  #s3_bucket                      = "${data.aws_s3_bucket.devops.id}"
  #s3_key                         = "${local.static_web_s3_key}"
  filename                       = "${local.output_file}"
  source_code_hash               = "${base64sha256(file("${local.output_file}"))}"
  function_name                  = "${local.service_identifier}"
  role                           = "${aws_iam_role.lambda_execution_role.arn}"
  handler                        = "logdna_cloudwatch.lambda_handler"
  runtime                        = "python2.7"
  publish                        = true
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"

  tags {
    Application = "${local.service_identifier}"
    Identifier  = "${var.service_identifier}"
  }
}
