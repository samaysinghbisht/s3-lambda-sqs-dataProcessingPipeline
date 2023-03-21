<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.3.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.59.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.sqs_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.csv_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_sqs_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.csv_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.lambda_sqs_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.csv_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.csv_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.csv_bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sqs_queue.csv_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.csv_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [archive_file.python_lambda_package](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 Bucket Name | `string` | `"csv-bucket123"` | no |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | Lambda Function Name | `string` | `"csv_lambda"` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | Name of IAM role for Lambda | `string` | `"csv_lambda_role"` | no |
| <a name="input_sqs_name"></a> [sqs\_name](#input\_sqs\_name) | SQS Queue Name | `string` | `"csv_queue"` | no |
| <a name="input_sqs_trigger"></a> [sqs\_trigger](#input\_sqs\_trigger) | Name of IAM Policy to trigger SQS | `string` | `"lambda_to_sqs_trigger"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->