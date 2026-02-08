variable "rule_name" {
  type        = string
  description = "EventBridge rule name"
}

variable "description" {
  type        = string
  default     = "Trigger Lambda remediation on Macie findings"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda remediation function"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda remediation function"
}
