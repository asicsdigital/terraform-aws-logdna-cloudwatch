# terraform-aws-logdna-cloudwatch
Terraform Module to deploy the LogDNA Cloudwatch Lambda
===========

A terraform module for deploying the LogDNA log integration lambda as described here: https://github.com/logdna/aws-cloudwatch

This module

- deploys the labmda from the LogDNA Repo
- Creates the required IAM resources

----------------------
#### Required
- `service_identifier` - service_identifier - Unique identifier for the app, used in naming resources. (ex: LogDNA-dev )
- `logdna_key` - LogDNA Ingestion Key


#### Optional
- `logdna_hostname` - LOGDNA_HOSTNAME Alternative Host Name - NOT YET Implemented
- `logdna_tags` - List of tags to add to log DNA, current region is always added, region is always added to the array
- `reserved_concurrent_executions` - Number of reserved concurrent executions (default 10)
- `url` - URL to script content. (Defaults to GitHub Master : https://raw.githubusercontent.com/logdna/aws-cloudwatch/master/logdna_cloudwatch.py)


Usage
-----

```hcl

module "logdna` -
  source             = "github.com/asicsdigital/terraform-aws-logdna-cloudwatch.git"
  service_identifier = "LogDNA-dev"
  logdna_key         = "secret_key"
}

resource "aws_cloudwatch_log_subscription_filter" "logdna_lambdafunction_logfilter` -
  name            = "test_lambdafunction_logfilter"
  log_group_name  = "some-log-group-name"
  filter_pattern  = "" # This is required, but can be empty
  destination_arn = "${module.logdna.lambda_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch` -
  statement_id   = "AllowExecutionFromCloudWatch-${module.logdna.function_name}-${data.aws_region.current.name}"
  action         = "lambda:InvokeFunction"
  function_name  = "${module.logdna.function_name}"
  principal      = "logs.amazonaws.com"
  source_arn     = "arn:aws:logs:us-east-1:123456789012:log-group:some-log-group-name:*"
}

```

Outputs
=======

- `script_body`     - Raw content of the script.
- `lambda_arn`      - arn of the aws_lambda_function resource
- `lambda_role_arn` - arn of the aws_iam_role resource
- `function_name`   - function name of the aws_lambda_function resource

Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======


[MIT License](LICENSE)
