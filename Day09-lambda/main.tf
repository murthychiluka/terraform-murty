
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Data source to track S3 object changes
data "aws_s3_object" "lambda_zip" {
  bucket = "lambdamurthy143"
  key    = "lambda.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda"
  s3_bucket     = data.aws_s3_object.lambda_zip.bucket
  s3_key        = data.aws_s3_object.lambda_zip.key
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  source_code_hash = data.aws_s3_object.lambda_zip.version_id

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}

# Compress-Archive -Path .\lambda_function.py -DestinationPath .\lambda_function.zip
# using powershell to create zip file for lambda function