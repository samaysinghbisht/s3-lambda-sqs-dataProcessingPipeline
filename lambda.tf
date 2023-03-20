# Archiving the script
data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function/csv-to-json.py"
  output_path = "csv-to-json.zip"
}

# Creating Lambda using the Python function created
resource "aws_lambda_function" "csv_lambda" {
  filename      = "csv-to-json.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.csv_lambda_role.arn
  handler       = "csv-to-json.lambda_handler"
  runtime       = "python3.8"
  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.csv_queue.url
    }
  }
}

# Adding s3 as a source for lambda
resource "aws_lambda_permission" "csv_lambda_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.csv_bucket.arn
}

# Adding destination for Lambda
resource "aws_lambda_function_event_invoke_config" "lambda_sqs_trigger" {
  function_name = aws_lambda_function.csv_lambda.function_name

  destination_config {
    on_success {
      destination = aws_sqs_queue.csv_queue.arn
    }
  }
}
