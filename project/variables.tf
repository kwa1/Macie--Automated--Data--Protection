variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDRs allowed to SSH into resources"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "s3_sensitive_bucket" {
  description = "Name of the sensitive S3 bucket"
  type        = string
}

variable "cloudtrail_bucket" {
  description = "Name of the CloudTrail bucket"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to Lambda deployment package"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "cloud-security"
  }
}
