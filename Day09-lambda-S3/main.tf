
provider "aws" {
  region = var.aws_region
}

# --- Zip the Lambda code locally ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/build/lambda.zip"
}

# --- S3 bucket to store the deployment package ---
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.project_name}-lambda-artifacts-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- Upload the zip to S3 ---
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda/lambda.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)  # triggers re-upload on code change
}

# --- IAM role for Lambda ---
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec-role"

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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- Lambda function, pulling code from S3 ---
resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "python3.12"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_code.key

  # Ensures Lambda updates when the zip content changes
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [aws_s3_object.lambda_code]
}