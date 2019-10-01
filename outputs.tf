output "script_body" {
  value = data.http.logdna_cloudwatch.body
}

output "lambda_arn" {
  value = aws_lambda_function.logdna_cloudwatch.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "function_name" {
  value = aws_lambda_function.logdna_cloudwatch.function_name
}

