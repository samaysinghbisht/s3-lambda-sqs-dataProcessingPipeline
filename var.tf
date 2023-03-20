variable "lambda_name" {
  type        = string
  description = "Lambda Function Name"
  default     = "csv_lambda"
}

variable "lambda_role" {
  type        = string
  description = "Name of IAM role for Lambda"
  default     = "csv_lambda_role"
}

variable "sqs_trigger" {
  type        = string
  description = "Name of IAM Policy to trigger SQS"
  default     = "lambda_to_sqs_trigger"
}

variable "bucket_name" {
  type        = string
  description = "S3 Bucket Name"
  default     = "csv-bucket123"
}

variable "sqs_name" {
  type        = string
  description = "SQS Queue Name"
  default     = "csv_queue"
}