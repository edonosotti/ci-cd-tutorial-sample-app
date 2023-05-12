#!/bin/bash



# Retrieve the instance IDs associated with the Auto Scaling Group
instance_ids=$(aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[?AutoScalingGroupName=='$ASG'].InstanceId" --output text)

RUN_COMMANDS="aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 882166133385.dkr.ecr.eu-central-1.amazonaws.com/nebo-repo &&\
              docker pull $ECR_REGISTRY/$ECR_REPOSITORY:latest &&\
              docker run -d -p 80:8000 $ECR_REGISTRY/$ECR_REPOSITORY:latest"

echo "Run_Command passed "
# Execute AWS SSM command on each instance
IFS=$'\n' read -rd '' -a instance_array <<< "$instance_ids"
for instance_id in "${instance_array[@]}"; do
    aws ssm send-command  --region $AWS_REGION --instance-ids $instance_id --document-name AWS-RunShellScript --parameters "commands=$RUN_COMMANDS"
done