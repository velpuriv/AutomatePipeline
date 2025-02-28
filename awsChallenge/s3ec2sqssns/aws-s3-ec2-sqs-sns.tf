provider "aws" {
  region = "us-west-2"
}

# IAM Role for EC2 instance
resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2S3ReadOnlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for least privilege access to S3
resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "S3ReadOnlyPolicy"
  description = "Grants read-only access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

# Create instance profile to attach role to EC2
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "EC2S3InstanceProfile"
  role = aws_iam_role.ec2_s3_role.name
}

# Attach instance profile to an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami                  = var.ami_id # Replace with valid AMI
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name = "EC2-S3-Least-Privilege"
  }
}

# S3 Bucket for Static Assets
resource "aws_s3_bucket" "static_assets" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "static_assets" {
  bucket                  = aws_s3_bucket.static_assets.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_assets.arn}/*"
      }
    ]
  })
}


# SNS Topic
resource "aws_sns_topic" "app_notifications" {
  name = "app-notifications"
}

# SQS Queue
resource "aws_sqs_queue" "app_queue" {
  name = "app-queue"
}

# SNS Subscription to SQS
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.app_notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.app_queue.arn
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.app_queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.app_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.app_notifications.arn
          }
        }
      }
    ]
  })
}

