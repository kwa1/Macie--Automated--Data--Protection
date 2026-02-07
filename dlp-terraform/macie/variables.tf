variable "s3_buckets" {
  description = "List of S3 bucket names to scan"
  type        = list(string)
}

# cost optimation
#variable "macie_object_scan_threshold" {
 # type    = number
#  default = 1000000  # Limit daily scans to 1 million objects
#}
