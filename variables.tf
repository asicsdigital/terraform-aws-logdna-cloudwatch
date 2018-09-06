variable "service_identifier" {
  description = "service_identifier - Unique identifier for the app, used in naming resources. (ex: LogDNA-dev )"
}

#variable "logdna_key" {
#  description = "logdna_key - LogDNA Ingestion key. LOGDNA_KEY"
#}

variable "reserved_concurrent_executions" {
  type        = "string"
  description = "Number of reserved concurrent executions (default 10)"
  default     = "10"
}

variable "url" {
  description = "URL to script content. Defaults to GitHub Master"
  default     = "https://raw.githubusercontent.com/logdna/aws-cloudwatch/master/logdna_cloudwatch.py"
}

#
#Environment variables:
#(Required) LOGDNA_KEY: LOGDNA_KEY YOUR_INGESTION_KEY_HERE
#(Optional) LOGDNA_HOSTNAME: Alternative Host Name
#(Optional) LOGDNA_TAGS: Comma-separated Tags
