

# Enable Security Hub account
resource "aws_securityhub_account" "main" {}

# Subscribe to CIS AWS Foundations Benchmark
resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# Enable automated Macie and GuardDuty findings ingestion
resource "aws_securityhub_member" "org_members" {
  for_each    = var.org_accounts
  account_id  = each.value
  email       = each.key
  status      = "ENABLED"
}

# Optional: Custom insight to track public S3 buckets with sensitive data
resource "aws_securityhub_insight" "public_s3_sensitive" {
  name        = "PublicS3WithSensitiveData"
  filters     = {
    ProductArn = ["arn:aws:securityhub:::product/aws/macie2"]
    ResourceType = ["AwsS3Object"]
    SeverityLabel = ["HIGH","CRITICAL"]
    RecordState   = ["ACTIVE"]
  }
  group_by_attribute = "ResourceId"
}
