# IAM Role for Lambda Remediation
resource "aws_iam_role" "lambda_remediation" {
  name = "lambda_remediation_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Least-privilege policy for Macie remediation
resource "aws_iam_policy" "lambda_macie_policy" {
  name        = "lambda_macie_policy"
  description = "Least-privilege policy for Macie remediation"
  policy      = file("${path.module}/policies/lambda_macie.json")
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_remediation.name
  policy_arn = aws_iam_policy.lambda_macie_policy.arn
}

# IAM password policy
resource "aws_iam_account_password_policy" "default" {
  minimum_password_length        = 14
  require_symbols                = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  allow_users_to_change_password = true
  max_password_age               = 90
}
