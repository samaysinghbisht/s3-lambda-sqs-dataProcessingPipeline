# Creating s3 bucket
resource "aws_s3_bucket" "csv_bucket" {
  bucket = var.bucket_name
}

# Creating event notification for S3 bucket
resource "aws_s3_bucket_notification" "csv_bucket_notification" {
  bucket = aws_s3_bucket.csv_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
