output "cloudtrail_id" {
  value = aws_cloudtrail.main.id
}

output "cloudtrail_bucket_arn" {
  value = aws_s3_bucket.cloudtrail.arn
}
