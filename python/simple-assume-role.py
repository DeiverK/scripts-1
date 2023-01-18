import boto3
import configparser

# Read credentials file
config = configparser.ConfigParser()
config.read(os.path.expanduser('~/.aws/credentials'))

# Get access key and secret key from credentials file
access_key = config.get('root', 'aws_access_key_id')
secret_key = config.get('root', 'aws_secret_access_key')

# Authenticate with MFA
mfa_code = input("Enter MFA code: ")
session = boto3.Session(
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    mfa_serial_number='arn:aws:iam::ACCOUNT_ID:mfa/USERNAME',
    mfa_token=mfa_code
)

# List S3 buckets
s3 = session.client('s3')
buckets = s3.list_buckets()
print(buckets)
