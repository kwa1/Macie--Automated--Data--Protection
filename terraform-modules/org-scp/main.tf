resource "aws_organizations_policy" "dlp_guardrails" {
  name        = "DLP-NonBypassable-Guardrails"
  description = "Prevents disabling DLP, Macie, and security controls"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # 1️⃣ Prevent Macie Disable
      {
        Sid    = "DenyMacieDisable"
        Effect = "Deny"
        Action = [
          "macie2:DisableMacie",
          "macie2:DeleteClassificationJob"
        ]
        Resource = "*"
      },

      # 2️⃣ Prevent GuardDuty Disable
      {
        Sid    = "DenyGuardDutyDisable"
        Effect = "Deny"
        Action = [
          "guardduty:DeleteDetector",
          "guardduty:StopMonitoringMembers"
        ]
        Resource = "*"
      },

      # 3️⃣ Prevent Security Hub Disable
      {
        Sid    = "DenySecurityHubDisable"
        Effect = "Deny"
        Action = [
          "securityhub:DisableSecurityHub"
        ]
        Resource = "*"
      },

      # 4️⃣ Prevent Removal of S3 Bucket Policies (DLP)
      {
        Sid    = "DenyS3PolicyRemoval"
        Effect = "Deny"
        Action = [
          "s3:DeleteBucketPolicy",
          "s3:PutBucketPolicy"
        ]
        Resource = "*"
      },

      # 5️⃣ Prevent removing sensitivity tags
      {
        Sid    = "DenySensitiveTagRemoval"
        Effect = "Deny"
        Action = [
          "s3:DeleteObjectTagging"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach" {
  policy_id = aws_organizations_policy.dlp_guardrails.id
  target_id = var.target_ou_id
}
