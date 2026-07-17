output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_bucket" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "lambda_s3_key" {
  value = aws_s3_object.lambda_code.key
}