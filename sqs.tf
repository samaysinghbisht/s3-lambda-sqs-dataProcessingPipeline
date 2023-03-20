# Creating SQS queue
resource "aws_sqs_queue" "csv_queue" {
  name = var.sqs_name
}

# Setting policies for SQS
resource "aws_sqs_queue_policy" "csv_queue_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = aws_sqs_queue.csv_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : aws_lambda_function.csv_lambda.arn
          }
        }
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  queue_url = aws_sqs_queue.csv_queue.url
}
