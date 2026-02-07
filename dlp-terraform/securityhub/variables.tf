variable "org_accounts" {
  description = "Map of email=>account_id for org members"
  type        = map(string)
  default     = {}
}
