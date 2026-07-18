module "iam" {
  source = "./iam"

  environment      = var.environment
  developer_users  = var.developer_users
  readonly_users   = var.readonly_users
}

output "developer_users" {
  value = module.iam.developer_user_names
}

output "ec2_role_arn" {
  value = module.iam.ec2_s3_role_arn
}