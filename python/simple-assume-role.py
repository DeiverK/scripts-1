import boto3

# Create an STS client
sts_client = boto3.client('sts')

# Assume the role
response = sts_client.assume_role(
    RoleArn='arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME',
    RoleSessionName='session_name',
    DurationSeconds=3600
)

# Use the returned credentials to create a new session
session = boto3.Session(
    aws_access_key_id=response['Credentials']['AccessKeyId'],
    aws_secret_access_key=response['Credentials']['SecretAccessKey'],
    aws_session_token=response['Credentials']['SessionToken']
)

# Use the new session to create a client for an AWS service
s3_client = session.client('s3')

# Make a call to the service using the assumed role
response = s3_client.list_buckets()
