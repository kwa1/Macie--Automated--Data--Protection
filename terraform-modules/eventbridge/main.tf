resource "aws_cloudwatch_event_rule" "macie_findings_rule" {
  name        = var.rule_name
  description = var.description
  event_pattern = jsonencode({
    source        = ["aws.macie2"],
    "detail-type" = ["Macie2 Findings"],
    detail        = {
      severity = ["HIGH","CRITICAL"]
    }
  })
}

resource "aws_cloudwatch_event_target" "macie_lambda_target" {
  rule      = aws_cloudwatch_event_rule.macie_findings_rule.name
  target_id = "LambdaRemediation"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.macie_findings_rule.arn
}
