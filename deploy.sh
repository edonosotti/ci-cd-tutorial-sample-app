#!/bin/bash


ASG=$1
DOCKER_IMMAGE=$2
AWS_REGION=$3

# Retrieve the instance IDs associated with the Auto Scaling Group
instance_ids=$(aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[?AutoScalingGroupName=='$ASG'].InstanceId" --output text)


RUN_COMMANDS="aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 882166133385.dkr.ecr.eu-central-1.amazonaws.com/nebo-repo &&\
              docker pull 882166133385.dkr.ecr.eu-central-1.amazonaws.com/nebo-repo:latest &&\
              docker run -d -p 80:8000 882166133385.dkr.ecr.eu-central-1.amazonaws.com/nebo-repo:latest"

# Execute AWS SSM command on each instance
IFS=$'\n' read -rd '' -a instance_array <<< "$instance_ids"
for instance_id in "${instance_array[@]}"; do
    aws ssm send-command --profile private --region $AWS_REGION --instance-ids $instance_id --document-name AWS-RunShellScript --parameters "commands=$RUN_COMMANDS"
done