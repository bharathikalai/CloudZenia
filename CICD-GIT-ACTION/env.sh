#!/bin/bash

# Check if branch name is provided
if [ -z "$1" ]; then
  echo "Branch name is required as the first argument."
  exit 1
fi

BRANCH_NAME=$1

# Set environment variables based on the branch name
if [ "$BRANCH_NAME" == "beta" ]; then
  echo "Setting environment variables for beta..."
  export AWS_REGION="beta-region"
  export AWS_ACCOUNT_ID="beta-account-id"
  export ECR_REPOSITORY="beta-repo-name"
  export ECS_CLUSTER_NAME="beta-cluster-name"
  export ECS_SERVICE_NAME="beta-service-name"
  export ECS_TASK_DEFINITION="beta-task-definition"
  export S3_BUCKET="beta-s3-bucket"
  export S3_KEY="beta-s3-key"
elif [ "$BRANCH_NAME" == "main" ]; then
  echo "Setting environment variables for production..."
  export AWS_REGION="prod-region"
  export AWS_ACCOUNT_ID="prod-account-id"
  export ECR_REPOSITORY="prod-repo-name"
  export ECS_CLUSTER_NAME="prod-cluster-name"
  export ECS_SERVICE_NAME="prod-service-name"
  export ECS_TASK_DEFINITION="prod-task-definition"
  export S3_BUCKET="prod-s3-bucket"
  export S3_KEY="prod-s3-key"
else
  echo "Unknown branch name: $BRANCH_NAME"
  exit 1
fi