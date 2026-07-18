# ============================================================
# GROUPS
# ============================================================

resource "aws_iam_group" "developers" {
  name = "${var.environment}-developers"
}

resource "aws_iam_group" "readonly" {
  name = "${var.environment}-readonly"
}

resource "aws_iam_group" "admins" {
  name = "${var.environment}-admins"
}

# ============================================================
# USERS
# ============================================================

resource "aws_iam_user" "developer" {
  for_each      = toset(var.developer_users)
  name          = each.value
  force_destroy = var.force_destroy

  tags = {
    Environment = var.environment
    Role        = "developer"
  }
}

resource "aws_iam_user" "readonly" {
  for_each      = toset(var.readonly_users)
  name          = each.value
  force_destroy = var.force_destroy

  tags = {
    Environment = var.environment
    Role        = "readonly"
  }
}

# ============================================================
# GROUP MEMBERSHIP
# ============================================================

resource "aws_iam_user_group_membership" "developer_membership" {
  for_each = aws_iam_user.developer
  user     = each.value.name
  groups   = [aws_iam_group.developers.name]
}

resource "aws_iam_user_group_membership" "readonly_membership" {
  for_each = aws_iam_user.readonly
  user     = each.value.name
  groups   = [aws_iam_group.readonly.name]
}

# ============================================================
# POLICIES
# ============================================================

# Developer policy: EC2 + S3 full access, but scoped (no IAM changes)
data "aws_iam_policy_document" "developer_policy" {
  statement {
    sid    = "EC2FullAccess"
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3FullAccess"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "DenyIAMChanges"
    effect = "Deny"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachUserPolicy",
      "iam:PutUserPolicy",
      "iam:CreateAccessKey"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "developer_policy" {
  name        = "${var.environment}-developer-policy"
  description = "Developer access: EC2/S3 full, no IAM management"
  policy      = data.aws_iam_policy_document.developer_policy.json
}

resource "aws_iam_group_policy_attachment" "developer_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

# Read-only policy
data "aws_iam_policy_document" "readonly_policy" {
  statement {
    sid    = "ReadOnlyAccess"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "readonly_policy" {
  name        = "${var.environment}-readonly-policy"
  description = "Read-only access to EC2 and S3"
  policy      = data.aws_iam_policy_document.readonly_policy.json
}

resource "aws_iam_group_policy_attachment" "readonly_attach" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}

# Admin policy: full account access via AWS managed policy
resource "aws_iam_group_policy_attachment" "admin_attach" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ============================================================
# ROLES (for cross-service / cross-account access, e.g. EC2 -> S3)
# ============================================================

# Role that EC2 instances can assume to access S3
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_s3_role" {
  name               = "${var.environment}-ec2-s3-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "ec2_s3_access" {
  statement {
    sid    = "S3ReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.environment}-app-bucket",
      "arn:aws:s3:::${var.environment}-app-bucket/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name   = "${var.environment}-ec2-s3-policy"
  policy = data.aws_iam_policy_document.ec2_s3_access.json
}

resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${var.environment}-ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}

# Role that a human/another account can assume (cross-account access example)
data "aws_iam_policy_document" "assume_role_cross_account" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "readonly_assumable_role" {
  name               = "${var.environment}-readonly-assumable-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_cross_account.json
  max_session_duration = 3600

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "readonly_assumable_attach" {
  role       = aws_iam_role.readonly_assumable_role.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}