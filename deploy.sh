#!/bin/bash

# Retrieve the instance IDs associated with the Auto Scaling Group

instance_ids=$(aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[?AutoScalingGroupName=='$ASG'].InstanceId" --output text)
echo "APP will be deployed to: $instance_ids"

RUN_COMMANDS="aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin 882166133385.dkr.ecr.eu-central-1.amazonaws.com/nebo-repo &&\
              echo "$IMAGE" > /home/ubuntu/image_name.txt &&\
              docker pull $ECR_REGISTRY/$ECR_REPOSITORY:latest &&\
              docker stop ci-cd-app || true &&\
              docker rm ci-cd-app   || true &&\
              docker run -d --name ci-cd-app -p 80:8000 -it $ECR_REGISTRY/$ECR_REPOSITORY:latest"

# Execute AWS SSM command on each instance
IFS=$'\n' read -rd '' -a instance_array <<< "$instance_ids"
for instance_id in "${instance_array[@]}"; do
    aws ssm send-command  --region $AWS_REGION --instance-ids $instance_id --document-name AWS-RunShellScript --parameters "commands=$RUN_COMMANDS"
done