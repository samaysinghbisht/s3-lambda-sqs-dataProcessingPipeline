### Task Description: 
Building a data processing pipeline in Lambda which takes CSVs from S3, processes them by converting the content of the CSVs to JSON and send the response to SQS(message queue).

**Have also created this documentation for further understanding on the Terraform functionality used [TF-Doc.md](TF-Doc.md)**

### AWS Services Involved:
* S3
* Lambda
* SQS
* CloudWatch (for monitoring purpose)

### Steps to get started:
Pre-Requisites: Terraform needs to be installed
* Run following commands to set up everything:
  - terraform init
  - terraform fmt
  - terraform validate
  - terraform plan
  - terraform apply
* Goto S3 upload all 3 files, and check SQS for new messages.
* Take down the whole infra:
  - Delete the files from S3 bucket
  - Run command
    - terraform destroy

### CSVs details:

Three CSVs will be provided, namely:
* customers_yyyymmdd.csv
* orders_yyyymmdd.csv
* items_yyyymmdd.csv

Customer CSV contains customer data with a _customer_reference_, orders CSV contains the list of orders with _order_reference_ against the _customer_reference_ and finally items CSV contains list of items and price against _order_reference_

### Actions to be performed:
* Configure a S3 bucket to receive the daily file uploads from the partner.
* Configure an S3 event notification for the bucket to trigger an AWS Lambda function as soon as the files are uploaded.
* Write an AWS Lambda function to perform following functions:
  - Read the CSV files from the S3 bucket and convert them to JSON format
  - Parse the data from the CSV files and create JSON for each customer and their orders
  - Send the JSON to AWS SQS
  - If unexpected input exists, create an error message in JSON and send it to SQS.
 * Create IaC script to setup the infrastructure.
 
> Note: Language used Python

### Scaling and Storage:
* The solution can scale easily as AWS Lambda scales automatically based on the incoming traffic.
* The processing capacity can be increased by adjusting the memory allocated to the Lambda function, which in turn increases the CPU and network capacity.
* The processed data can be stored in Amazon Simple Storage Service (S3) or Amazon DynamoDB.
* S3 can be used to store the JSON messages and DynamoDB can be used to store the processed data in a tabular format, which can be queried later.

### Improvments:
To improve the setup, we can consider the following approaches:
* Add error handling and retries to the Lambda function to handle any unexpected errors.
