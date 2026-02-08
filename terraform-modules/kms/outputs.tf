output "kms_key_id" {
  value = aws_kms_key.main.id
}

output "kms_alias" {
  value = aws_kms_alias.main.name
}

