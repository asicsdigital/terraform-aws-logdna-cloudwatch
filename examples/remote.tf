data "vault_generic_secret" "logdna" {
  path = "secret/logdna"
}

module "logdna" {
  source             = "github.com/asicsdigital/terraform-aws-logdna-cloudwatch.git"
  service_identifier = "LogDNA-${var.env}"
  logdna_key         = "${data.vault_generic_secret.logdna.data["logdna_key"]}"
}

resource "aws_cloudwatch_log_subscription_filter" "logdna_lambdafunction_logfilter" {
  name            = "consul_${var.env}_lambdafunction_logfilter"
  log_group_name  = "consul-${var.env}"
  filter_pattern  = ""
  destination_arn = "${module.logdna.lambda_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch-${module.logdna.function_name}-${data.aws_region.current.name}"
  action        = "lambda:InvokeFunction"
  function_name = "${module.logdna.function_name}"
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:consul-${var.env}:*"
}
