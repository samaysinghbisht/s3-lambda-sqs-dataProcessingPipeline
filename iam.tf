# IAM role for Lambda function
resource "aws_iam_role" "csv_lambda_role" {
  name = var.lambda_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy attachment to allow Lambda Function to push logs to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.csv_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Policy to allow Lambda Function to send messages to SQS
resource "aws_iam_policy" "sqs_trigger" {
  name   = var.sqs_trigger
  policy = file("${path.module}/policy.json")
}

# IAM role to trigger SQS from Lambda
resource "aws_iam_role_policy_attachment" "lambda_sqs_trigger" {
  role       = aws_iam_role.csv_lambda_role.name
  policy_arn = aws_iam_policy.sqs_trigger.arn
}
