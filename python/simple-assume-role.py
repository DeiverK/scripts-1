import boto3
import configparser

def authenticate_root_account(mfa_code):
    # Read credentials file
    config = configparser.ConfigParser()
    config.read(os.path.expanduser("~/.aws/credentials"))

    # Get access key and secret key
    access_key = config.get("default", "aws_access_key_id")
    secret_key = config.get("default", "aws_secret_access_key")

    # Create STS client
    client = boto3.client("sts", aws_access_key_id=access_key, aws_secret_access_key=secret_key)

    # Get MFA session credentials
    response = client.get_session_token(DurationSeconds=3600, SerialNumber=mfa_code)

    # Return MFA session credentials
    return response["Credentials"]

def list_s3_buckets():
    # Get MFA session credentials
    mfa_credentials = authenticate_root_account(input("Enter MFA code: "))

    # Create S3 client with MFA session credentials
    s3 = boto3.client("s3", aws_access_key_id=mfa_credentials["AccessKeyId"],
                      aws_secret_access_key=mfa_credentials["SecretAccessKey"],
                      aws_session_token=mfa_credentials["SessionToken"])

    # List S3 buckets
    response = s3.list_buckets()
    buckets = response["Buckets"]

    # Print S3 bucket names
    for bucket in buckets:
        print(bucket["Name"])

if __name__ == "__main__":
    list_s3_buckets()
