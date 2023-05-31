#!/bin/bash

# Function to get the list of service accounts in Kubernetes
get_service_accounts() {
  kubectl get serviceaccounts --output=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
}

# Function to get the role assigned to a service account in Kubernetes
get_service_account_role() {
  local service_account="$1"
  kubectl get serviceaccount "$service_account" --output=jsonpath='{.metadata.annotations.eks\.amazonaws\.com/role-arn}'
}

# Function to validate if the role exists in AWS
validate_aws_role() {
  local role_arn="$1"
  aws iam get-role --role-name "$(basename "$role_arn")" >/dev/null 2>&1
}

# Main script

# Get the list of service accounts
service_accounts=$(get_service_accounts)

# Iterate through each service account
while IFS= read -r service_account; do
  echo "Service Account: $service_account"
  
  # Get the associated role
  role_arn=$(get_service_account_role "$service_account")
  echo "Role ARN: $role_arn"

  # Validate the role in AWS
  if validate_aws_role "$role_arn"; then
    echo "Role exists in AWS"
  else
    echo "Role does not exist in AWS"
  fi

  echo "----------------------"
done <<<"$service_accounts"
