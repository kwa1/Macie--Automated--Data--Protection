package terraform.lambda

deny[msg] {
  input.resource_type == "aws_iam_policy"
  input.policy_document.Statement[_].Action[_] == "*"
  contains(input.policy_document.Statement[_].Resource[_], "s3")
  msg = sprintf("IAM Policy %v grants wildcard S3 permissions", [input.name])
}
