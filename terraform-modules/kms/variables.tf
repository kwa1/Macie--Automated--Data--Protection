variable "alias_name" {
  type        = string
  description = "KMS Key alias"
}

variable "description" {
  type        = string
  default     = "KMS key for sensitive data encryption"
}
