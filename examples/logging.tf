module "logdna" {
  source             = "github.com/asicsdigital/terraform-aws-logdna-cloudwatch.git"
  service_identifier = "LogDNA-dev"
  logdna_key         = "secret_key"
}

resource "aws_cloudwatch_log_subscription_filter" "logdna_lambdafunction_logfilter" {
  name            = "test_lambdafunction_logfilter"
  log_group_name  = "some-log-group-name"
  filter_pattern  = ""                              # This is required, but can be empty
  destination_arn = "${module.logdna.lambda_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch-${module.logdna.function_name}-${data.aws_region.current.name}"
  action        = "lambda:InvokeFunction"
  function_name = "${module.logdna.function_name}"
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:us-east-1:123456789012:log-group:some-log-group-name:*"
}
