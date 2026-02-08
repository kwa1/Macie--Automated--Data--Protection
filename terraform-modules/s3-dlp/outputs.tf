output "dlp_policy_id" {
  value       = aws_s3_bucket_policy.dlp.id
  description = "ID of the applied DLP bucket policy"
}
