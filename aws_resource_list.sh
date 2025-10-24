#!/bin/bash

###############################################################################
# Author: Deepak Kumar
# Version: v1.0.0
#
# Script to automate the process of listing all the resources in an AWS account
# This script only works on machines where AWS CLI is installed and configured.
#
# Supported services:
# EC2, RDS, S3, CloudFront, VPC, IAM, Route53, CloudWatch, CloudFormation,
# Lambda, SNS, SQS, DynamoDB, and EBS.
#
# Usage: ./aws_resource_list.sh <aws_region> <aws_service>
# Example: ./aws_resource_list.sh us-east-1 ec2
###############################################################################

if [ $# -ne 2 ]; then
    echo "Usage: ./aws_resource_list.sh <aws_region> <aws_service>"
    echo "Example: ./aws_resource_list.sh us-east-1 ec2"
    exit 1
fi

aws_region=${1,,}
aws_service=${2,,}

if ! command -v aws &> /dev/null; then 
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi

if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure it and try again."
    exit 1
fi

case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        aws ec2 describe-instances --region $aws_region --output table
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        aws rds describe-db-instances --region $aws_region --output table
        ;;
    s3)
        echo "Listing S3 Buckets"
        aws s3api list-buckets --query "Buckets[].Name" --output table
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions"
        aws cloudfront list-distributions --output table
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        aws ec2 describe-vpcs --region $aws_region --output table
        ;;
    iam)
        echo "Listing IAM Users"
        aws iam list-users --output table
        ;;
    route53)
        echo "Listing Route53 Hosted Zones"
        aws route53 list-hosted-zones --output table
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region $aws_region --output table
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region $aws_region --output table
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region $aws_region --output table
        ;;
    sns)
        echo "Listing SNS Topics"
        aws sns list-topics --output table
        ;;
    sqs)
        echo "Listing SQS Queues"
        aws sqs list-queues --region $aws_region --output table
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        aws dynamodb list-tables --region $aws_region --output table
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region $aws_region --output table
        ;;
    *)
        echo "Invalid service. Please enter a valid service name."
        exit 1
        ;;
esac