data "aws_iam_policy_document" "dlp" {

  #
  # 1️⃣ HARD DENY: Download sensitive objects
  #
  statement {
    sid     = "DenyDownloadOfSensitiveObjects"
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:ExistingObjectTag/Sensitive"
      values   = ["true"]
    }
  }

  #
  # 2️⃣ DENY presigned URLs (anonymous exfiltration)
  #
  statement {
    sid     = "DenyPresignedURLAccess"
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalType"
      values   = ["Anonymous"]
    }
  }

  #
  # 3️⃣ OPTIONAL: Allow break-glass / security roles
  #
  dynamic "statement" {
    for_each = length(var.break_glass_role_arns) > 0 ? [1] : []

    content {
      sid     = "AllowBreakGlassRoles"
      effect  = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.break_glass_role_arns
      }

      actions = [
        "s3:GetObject"
      ]

      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "dlp" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.dlp.json
}
