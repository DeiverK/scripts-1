#!/bin/bash

# List of AWS accounts to connect to
accounts=("123456789012" "098765432109" "234567890123")

# Loop through each account
for account in "${accounts[@]}"
do
    # Set the AWS_PROFILE for the account
    export AWS_PROFILE="account-${account}"

    # Get the list of EKS clusters
    clusters=$(aws eks list-clusters)

    # Loop through each cluster
    for cluster in $clusters
    do
        # Get the cluster version
        version=$(aws eks describe-cluster --name $cluster --query 'cluster.version')

        # Print the cluster and version
        echo "Account: ${account} Cluster: ${cluster} Version: ${version}"
    done
done
