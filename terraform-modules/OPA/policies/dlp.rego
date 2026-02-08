package dlp.guardrails

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  not resource.change.after.server_side_encryption_configuration
  msg := "S3 bucket must enforce SSE-KMS encryption"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_macie2_account"
  resource.change.after.status != "ENABLED"
  msg := "Macie must be enabled"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_cloudtrail"
  resource.change.after.is_multi_region_trail != true
  msg := "CloudTrail must log all regions"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_lambda_function"
  perms := resource.change.after.role
  contains(perms, "*")
  msg := "Lambda must not use wildcard permissions"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_policy"
  not contains(resource.change.after.policy, "Sensitive")
  msg := "S3 bucket must enforce DLP tag-based deny"
}
