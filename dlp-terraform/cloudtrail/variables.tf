variable "cloudtrail_bucket" {
  type        = string
  description = "S3 bucket for CloudTrail logs"
}

variable "kms_key_id" {
  type        = string
  description = "KMS key for CloudTrail encryption"
}
