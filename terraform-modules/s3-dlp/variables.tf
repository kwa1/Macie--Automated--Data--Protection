variable "bucket_name" {
  description = "S3 bucket to enforce DLP controls on"
  type        = string
}

variable "break_glass_role_arns" {
  description = "IAM roles allowed to download sensitive data (security/admin only)"
  type        = list(string)
  default     = []
}
