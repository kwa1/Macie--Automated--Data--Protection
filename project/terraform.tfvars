aws_region          = "us-east-1"
vpc_id              = "vpc-0abcd1234efgh5678"
allowed_ssh_cidrs   = ["203.0.113.0/24"]
s3_sensitive_bucket = "prod-sensitive-data"
cloudtrail_bucket   = "prod-cloudtrail-logs"
lambda_zip_path     = "../lambda/remediation.zip"

common_tags = {
  Environment = "prod"
  Project     = "cloud-security"
  Owner       = "CloudSecTeam"
}
