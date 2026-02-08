output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.macie_findings_rule.arn
}

output "event_rule_name" {
  value = aws_cloudwatch_event_rule.macie_findings_rule.name
}
