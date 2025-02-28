variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-027951e78de46a00e"
}

variable "key_pair_name" {
  description = "Existing key pair name"
  default     = "github-actions-ec2-key-pair"
}

variable "s3_bucket_name" {
  description = "Existing busket name"
  default     = "myapp-bucket3421-0098app022-022810182025"
}

variable "instance_type" {
  description = "instance_type"
  default     = "t3.medium"
}

