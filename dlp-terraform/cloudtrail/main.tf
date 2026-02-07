resource "aws_s3_bucket" "cloudtrail" {
  bucket = var.cloudtrail_bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_cloudtrail" "main" {
  name                          = "organization-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  kms_key_id                    = var.kms_key_id
}
