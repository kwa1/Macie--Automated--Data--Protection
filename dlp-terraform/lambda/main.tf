resource "aws_lambda_function" "remediation" {
  function_name = "s3_macie_remediation"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = var.lambda_role_arn
  filename      = var.zip_file_path
}

resource "aws_cloudwatch_event_rule" "macie_findings" {
  name = "macie-findings-rule"

  event_pattern = jsonencode({
    source        = ["aws.macie2"]
    "detail-type" = ["Macie Finding"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.macie_findings.name
  arn  = aws_lambda_function.remediation.arn
}

resource "aws_iam_policy" "macie_remediation_policy" {
  name = "macie-remediation-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "macie2:Get*",
          "macie2:List*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
