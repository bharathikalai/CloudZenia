#!/bin/bash
set -e

# Check if required environment variables are set
if [ -z "$AWS_REGION" ] || [ -z "$AWS_ACCOUNT_ID" ] || [ -z "$ECR_REPOSITORY" ]; then
  echo "One or more required environment variables are not set."
  echo "Please set AWS_REGION, AWS_ACCOUNT_ID, and ECR_REPOSITORY."
  exit 1
fi

# Login to AWS ECR
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build Docker image
echo "Building Docker image..."
docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest ./micro-service-ECS

# Push Docker image to AWS ECR
echo "Pushing Docker image to AWS ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

echo "Docker image pushed successfully."

# Deploy to ECS
echo "Deploying to ECS..."
TASK_DEFINITION_JSON=$(aws ecs describe-task-definition --task-definition $ECS_TASK_DEFINITION)
NEW_TASK_DEFINITION=$(echo $TASK_DEFINITION_JSON | jq --arg IMAGE "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest" '.taskDefinition | .containerDefinitions[0].image=$IMAGE | del(.revision,.status,.taskDefinitionArn,.requiresAttributes,.compatibilities,.registeredAt,.registeredBy)')
NEW_TASK_DEFINITION=$(echo $NEW_TASK_DEFINITION | jq '.family=$ECS_TASK_DEFINITION')
aws ecs register-task-definition --cli-input-json "$NEW_TASK_DEFINITION"
aws ecs update-service --cluster $ECS_CLUSTER_NAME --service $ECS_SERVICE_NAME --force-new-deployment

echo "Deployment to ECS completed successfully."