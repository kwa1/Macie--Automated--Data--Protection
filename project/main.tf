terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------
# 1. IAM
# --------------------------
module "iam" {
  source           = "./terraform-modules/iam"
  lambda_role_name = "lambda_remediation_role"
}

# --------------------------
# 2. KMS
# --------------------------
module "kms" {
  source      = "./terraform-modules/kms"
  alias_name  = "macie_kms"
  description = "KMS key for S3 encryption and CloudTrail"
}

# --------------------------
# 3. S3 (for sensitive data)
# --------------------------
module "s3_sensitive" {
  source      = "./terraform-modules/s3"
  bucket_name = var.s3_sensitive_bucket
  kms_key_id  = module.kms.kms_key_id
  tags        = var.common_tags
}

# --------------------------
# 4. Macie
# --------------------------
module "lambda_remediation" {
  source = "./terraform-modules/lambda-remediation"

  lambda_name = "remediate-sensitive-data"
  s3_buckets  = var.s3_buckets
  # ...other variables
}

module "macie" {
  source      = "./terraform-modules/macie"
  s3_buckets  = var.s3_buckets
  lambda_arn  = module.lambda_remediation.lambda_arn
  lambda_name = module.lambda_remediation.lambda_name
}

module "eventbridge" {
  source      = "./terraform-modules/eventbridge"
  rule_name   = "macie-findings-event"
  lambda_arn  = module.lambda_remediation.lambda_arn
  lambda_name = module.lambda_remediation.lambda_name
}


# --------------------------
# 5. Lambda Remediation
# --------------------------
module "lambda_remediation" {
  source         = "./terraform-modules/lambda-remediation"
  lambda_role_arn = module.iam.lambda_role_arn
  zip_file_path   = var.lambda_zip_path
}

# --------------------------
# 6. CloudTrail
# --------------------------
module "cloudtrail" {
  source           = "./terraform-modules/cloudtrail"
  cloudtrail_bucket = var.cloudtrail_bucket
  kms_key_id        = module.kms.kms_key_id
}

# --------------------------
# 7. GuardDuty
# --------------------------
module "guardduty" {
  source = "./terraform-modules/guardduty"
}

# --------------------------
# 8. SecurityHub
# --------------------------
module "securityhub" {
  source = "./terraform-modules/securityhub"
}
-----------------------------------------------------
# 9. eventbridge
--------------------------------------------------------
 module "eventbridge" {
  source      = "./terraform-modules/eventbridge"
  rule_name   = "macie-findings-event"
  lambda_arn  = module.lambda_remediation.lambda_arn
  lambda_name = module.lambda_remediation.lambda_name
}  
# --------------------------
# 10. Network Security
# --------------------------
module "network" {
  source           = "./terraform-modules/network-security"
  vpc_id           = var.vpc_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

# --------------------------
# Outputs (aggregated)
# --------------------------
output "s3_sensitive_bucket_arn" {
  value = module.s3_sensitive.bucket_arn
}

output "lambda_remediation_arn" {
  value = module.lambda_remediation.lambda_function_arn
}

output "kms_key_arn" {
  value = module.kms.kms_key_id
}

output "iam_lambda_role_arn" {
  value = module.iam.lambda_role_arn
}
