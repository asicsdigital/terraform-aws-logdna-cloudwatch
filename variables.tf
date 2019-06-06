variable "logdna_hostname" {
  description = "LOGDNA_HOSTNAME Alternative Host Name"
  default     = ""
}

variable "logdna_key" {
  description = "LogDNA Ingestion Key"
}

variable "logdna_tags" {
  type        = "list"
  description = "List of tags to add to log DNA, current region is always added"
  default     = []
}

variable "reserved_concurrent_executions" {
  type        = "string"
  description = "Number of reserved concurrent executions (default 10)"
  default     = "10"
}

variable "service_identifier" {
  description = "service_identifier - Unique identifier for the app, used in naming resources. (ex: LogDNA-dev )"
}

variable "url" {
  description = "URL to script content. Defaults to GitHub Master"
  default     = "https://raw.githubusercontent.com/logdna/aws-cloudwatch/0.1.0/logdna_cloudwatch.py"
}
