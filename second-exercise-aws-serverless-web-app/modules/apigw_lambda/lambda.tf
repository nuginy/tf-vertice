locals {
  default_policies = [
    {
      effect = "Allow"

      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]

      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      actions = [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ]
      effect    = "Allow"
      resources = [var.dynamodb_arn]
    }
  ]
  policies = concat(local.default_policies, var.lambda_policies)
}

resource "aws_iam_role" "iam_role_lamda" {
  name_prefix        = "${var.lambda_name}TfRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
}

data "aws_iam_policy_document" "lambda_statements" {
#  statement {
#    effect = "Allow"
#
#    actions = [
#      "logs:CreateLogGroup",
#      "logs:CreateLogStream",
#      "logs:PutLogEvents",
#    ]
#
#    resources = ["arn:aws:logs:*:*:*"]
#  }
#
#  statement {
#    actions = [
#      "dynamodb:PutItem",
#      "dynamodb:DeleteItem",
#      "dynamodb:GetItem",
#      "dynamodb:Scan",
#      "dynamodb:Query",
#      "dynamodb:UpdateItem"
#    ]
#    effect    = "Allow"
#    resources = [var.dynamodb_arn]
#  }

  dynamic "statement" {
    for_each = local.policies
    content {
      actions   = statement.value["actions"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
    }
  }
  depends_on = [var.dynamodb_arn]
}

resource "aws_iam_role_policy" "lambda_policy" {
  policy     = data.aws_iam_policy_document.lambda_statements.json
  role       = aws_iam_role.iam_role_lamda.id
  depends_on = [data.aws_iam_policy_document.lambda_statements]
}


data "archive_file" "zip_file" {
  type        = "zip"
  output_path = "lambda_zip_file_int.zip"
  source {
    content  = file(var.lambda_path)
    filename = "lambda_function.py"
  }
}

resource "aws_cloudwatch_log_group" "lambda_function" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
}

resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.zip_file.output_path
  source_code_hash = data.archive_file.zip_file.output_base64sha256
  function_name    = "${var.lambda_name}Tf"
  role             = aws_iam_role.iam_role_lamda.arn
  description      = var.lambda_description
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_function.id
  }
  runtime                        = "python3.8"
  handler                        = var.lambda_handler
  memory_size                    = var.lambda_memory_size
  reserved_concurrent_executions = var.lambda_concurrency
  tags                           = merge(var.tags, {
    DeployTime = timestamp()
  })
}

resource "aws_lambda_permission" "lambda_invoke" {
  statement_id  = "InvokePermissionFromApiGw"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.web_app.execution_arn}/*/*"
}