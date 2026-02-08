package terraform.cloudtrail

deny[msg] {
  input.resource_type == "aws_cloudtrail"
  not input.is_multi_region_trail
  msg = sprintf("CloudTrail %v does not log all regions", [input.name])
}
