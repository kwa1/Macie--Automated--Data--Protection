output "s3_sensitive_bucket_id" {
  value = module.s3_sensitive.bucket_id
}

output "macie_account_id" {
  value = module.macie.macie_account_id
}

output "cloudtrail_id" {
  value = module.cloudtrail.cloudtrail_id
}

output "guardduty_detector_id" {
  value = module.guardduty.guardduty_detector_id
}

output "securityhub_account_id" {
  value = module.securityhub.securityhub_account_id
}

output "network_security_group_id" {
  value = module.network.security_group_id
}
