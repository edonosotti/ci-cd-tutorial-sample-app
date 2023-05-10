#!/bin/bash



ASG_STAGE="asg_stage"
AWS_REGION="eu-central-1"




# Retrieve the instance IDs associated with the Auto Scaling Group
instance_ids=$(aws autoscaling describe-auto-scaling-instances --profile private --query "AutoScalingInstances[?AutoScalingGroupName=='$ASG_STAGE'].InstanceId" --output text)

# Print the list of instance IDs
echo "Instance IDs:"
echo "$instance_ids"

RUN_COMMANDS= "touch /home/ubuntu/test555.txt"

# Execute AWS SSM command on each instance
IFS=$'\n' read -rd '' -a instance_array <<< "$instance_ids"
for instance_id in "${instance_array[@]}"; do
    echo "Processing instance: $instance_id"

    # Escape the instance ID
    escaped_instance_id=$(printf '%s' "$instance_id" | sed -e 's/"/\\"/g')
	echo "$escaped_instance_id"

    # Execute AWS SSM command on the instance
    aws ssm send-command \
        --profile private \
        --region $AWS_REGION \
        --instance-ids $instance_id \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=$RUN_COMMANDS '
done
