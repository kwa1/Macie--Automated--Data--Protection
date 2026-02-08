resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }

  lifecycle_rule {
    id      = "cleanup"
    enabled = true
    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_public_access_block" "secure_bucket" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
