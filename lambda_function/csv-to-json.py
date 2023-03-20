import json
import csv
import boto3
import os
from io import StringIO

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')
sqs_queue_url = os.environ['SQS_QUEUE_URL']

def lambda_handler(event, context):
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    file_prefix = object_key.split("_")[0]

    num_files = 3
    
    if file_prefix not in ['customers', 'orders', 'items']:
        return {
            'statusCode': 400,
            'body': f'Invalid file prefix: {file_prefix}'
        }
    
    response = s3_client.list_objects_v2(
        Bucket=bucket_name
    )

    files = response.get('Contents', [])

    if len(files) == num_files:
        # Process files here
        process_files(files, bucket_name)
            
def process_files(files, bucket_name):
    # Logic to process the files here
    customers = []
    orders = []
    items = []
    for file in files:
        file_type = file["Key"].split('_')[0]

        try:
            s3_object = s3_client.get_object(Bucket=bucket_name, Key=file["Key"])
            data = s3_object['Body'].read().decode('utf-8')
            csv_file = StringIO(data)
            csv_reader = csv.DictReader(csv_file)

            if file_type == 'customers':
                for row in csv_reader:
                    customers.append(row)
                    
            elif file_type == 'orders':
                for row in csv_reader:
                    orders.append(row)
                    
            elif file_type == 'items':
                for row in csv_reader:
                    items.append(row)

        except Exception as e:
            error_message = {
                'type': 'error_message',
                'customer_reference': 'Null',
                'order_reference': 'Null',
                'message': 'Something Went Wrong!'
            }

            sqs_client.send_message(
                QueueUrl=sqs_queue_url,
                MessageBody=json.dumps(error_message)
            )
            return
    
    # Process the data
    customer_dict = process_data(customers, orders, items)

    # Send messages to SQS
    for customer_reference, customer_data in customer_dict.items():

        number_of_orders = customer_data['number_of_orders']
        total_amount_spent = customer_data['total_amount_spent']
        
        # Create customer message
        customer_message = {
            'type': 'customer_message',
            'customer_reference': customer_reference,
            'number_of_orders': number_of_orders,
            'total_amount_spent': total_amount_spent
        }
        sqs_client.send_message(
            QueueUrl=sqs_queue_url,
            MessageBody=json.dumps(customer_message)
        )


def process_data(customers, orders, items):
    # Create a dictionary to store customer data
    customer_dict = {}
    error_message = {}
    for customer in customers:
        customer_name = customer['first_name'] +" "+ customer['last_name'] 
        customer_reference = customer['customer_reference']
        if customer_reference not in customer_dict:
            customer_dict[customer_reference] = {
                'customer_reference': customer_reference,
                'name': customer_name,
                'number_of_orders': 0,
                'total_amount_spent': 0
            }
    
    # Process orders and items data
    for order in orders:

        order_reference = order['order_reference']

        try:
            customer_reference = order['customer_reference']
    
            if customer_reference in customer_dict:
                customer_dict[customer_reference]["number_of_orders"] += 1
    
                # Process items data
                total_price = 0
                for item in items:
                    if item['order_reference'] == order_reference:
                        total_price += float(item['total_price'])
    
                customer_dict[customer_reference]['total_amount_spent'] += total_price
            
            else:
                if order_reference not in error_message:
                    error_message[order_reference] = {
                        'type': 'error_message',
                        'customer_reference': 'Null',
                        'order_reference': order_reference,
                        'message': 'Something Went Wrong'
                    }
                    sqs_client.send_message(
                        QueueUrl=sqs_queue_url,
                        MessageBody=json.dumps(error_message[order_reference])
                    )
                
        except Exception as e:
            if order_reference not in error_message:
                error_message[order_reference] = {
                    'type': 'error_message',
                    'customer_reference': 'Null',
                    'order_reference': order_reference,
                    'message': 'Something Went Wrong'
                }
                sqs_client.send_message(
                    QueueUrl=sqs_queue_url,
                    MessageBody=json.dumps(error_message[order_reference])
                )

    return customer_dict