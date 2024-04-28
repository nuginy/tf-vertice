output "dynamodb_table_arn" {
  value = module.dynamo_db.dynamodb_arn
}

output "apigw_invoke_url" {
  value = module.apigw_lambda.api_gw_invoke_url
}

output "amplify_default_domain" {
  value = module.amplify.amplify_domain
}