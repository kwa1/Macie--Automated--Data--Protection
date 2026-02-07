package terraform.s3

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.server_side_encryption_configuration
  msg = sprintf("Bucket %v does not have SSE-KMS enabled", [input.name])
}
