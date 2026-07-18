output "developer_user_names" {
  value = [for u in aws_iam_user.developer : u.name]
}

output "readonly_user_names" {
  value = [for u in aws_iam_user.readonly : u.name]
}

output "developers_group_name" {
  value = aws_iam_group.developers.name
}

output "readonly_group_name" {
  value = aws_iam_group.readonly.name
}

output "ec2_s3_role_arn" {
  value = aws_iam_role.ec2_s3_role.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_s3_profile.name
}

output "readonly_assumable_role_arn" {
  value = aws_iam_role.readonly_assumable_role.arn
}