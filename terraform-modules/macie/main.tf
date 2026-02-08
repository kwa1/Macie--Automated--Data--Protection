resource "aws_macie2_account" "this" {}

resource "aws_macie2_classification_job" "s3_scan" {
  name       = "s3-sensitive-data-scan"
  job_type   = "ONE_TIME"
  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.current.account_id
      buckets    = var.s3_buckets
    }
  }
}

# ----------cost optimation gaurdrails/

#resource "aws_macie2_classification_job" "s3_scan" {
#  count      = length(var.s3_buckets) <= 5 ? 1 : 0  # Only allow up to 5 buckets
#  name       = "s3-sensitive-data-scan"
#  job_type   = "ONE_TIME"
#  s3_job_definition {
#   bucket_definitions {
#      account_id = data.aws_caller_identity.current.account_id
 #     buckets    = var.s3_buckets
 #   }
#  }
#}
