variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "kms_key_id" {
  description = "KMS key ARN for encryption"
  type        = string
}
