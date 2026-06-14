provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda_payload_zip" {
  type        = "zip"
  source_file = "${path.module}/cloud_track.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_iam_role" "serverless_execution_identity" {
  name = "abstracted_metric_tracker_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "://amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "base_execution_logs_attachment" {
  role       = aws_iam_role.serverless_execution_identity.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "monitoring_lambda_instance" {
  filename         = data.archive_file.lambda_payload_zip.output_path
  function_name    = "enterprise_inventory_monitoring_engine"
  role             = aws_iam_role.serverless_execution_identity.arn
  handler          = "cloud_track.main"
  runtime          = "python3.10"
  timeout          = 45
  memory_size      = 512
  source_code_hash = data.archive_file.lambda_payload_zip.output_base64sha256

  # Exposes the range tracking boundaries cleanly to recruiters
  environment {
    variables = {
      MIN_METRIC_VALUE           = "2500"
      MAX_METRIC_VALUE           = "3300"
      TARGET_RESOURCE_ENDPOINT_A = "generic_sku_placeholder_a"
      TARGET_RESOURCE_ENDPOINT_B = "generic_sku_placeholder_b"
    }
  }
}

resource "aws_cloudwatch_event_rule" "cron_latency_pattern" {
  name                = "low_latency_event_streaming_trigger"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.cron_latency_pattern.name
  target_id = "InvokeTargetLambdaFunction"
  arn       = aws_lambda_function.monitoring_lambda_instance.arn
}

resource "aws_lambda_permission" "grant_eventbridge_invocation_access" {
  statement_id  = "AllowExecutionFromEventBridgeTriggers"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.monitoring_lambda_instance.function_name
  principal     = "://amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_latency_pattern.arn
}
