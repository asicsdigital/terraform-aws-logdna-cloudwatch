variable "logdna_hostname" {
  description = "LOGDNA_HOSTNAME Alternative Host Name"
  default     = ""
}

variable "logdna_key" {
  description = "LogDNA Ingestion Key"
}

variable "logdna_tags" {
  type        = list(string)
  description = "List of tags to add to log DNA, current region is always added"
  default     = []
}

variable "reserved_concurrent_executions" {
  type        = string
  description = "Number of reserved concurrent executions (default 10)"
  default     = "10"
}

variable "service_identifier" {
  description = "service_identifier - Unique identifier for the app, used in naming resources. (ex: LogDNA-dev )"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for the lambda"
  default     = 3
}
