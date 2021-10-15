resource "aws_sns_topic" "rebuild_event_topic" {
  name = "${var.username}-${var.project_name}-rebuild-event"

    lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_lambda_function" "this" {
  filename = "../dist/function.zip"
  function_name = "self_healing_utility_function"
  handler = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn


  source_code_hash = filebase64sha256("../dist/function.zip")
  runtime = "nodejs14.x"

  environment {
    variables = {
      GITHUB_USERNAME = "liam-johnston"
      GITHUB_REPO = "pathways-node-weather-app-quick-start-base-infra"
      GITHUB_TOKEN_SECRET_NAME = aws_secretsmanager_secret.github_access_token.name
    }
  }
}

resource "aws_sns_topic_subscription" "sns_lambda_sub" {
  topic_arn = aws_sns_topic.rebuild_event_topic.arn
  protocol = "lambda"
  endpoint = aws_lambda_function.this.arn
}
