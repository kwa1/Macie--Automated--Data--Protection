resource "aws_kms_key" "main" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.main.id
}
