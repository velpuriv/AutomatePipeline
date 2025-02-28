variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_public" {
  default = "10.0.1.0/24"
}

variable "ec2_instance_type" {
  default = "t3.medium"
}

variable "ssh_key_name" {
  default = "github-actions-ec2-key-pair"
}

variable "ec2_ami" {
  default = "ami-027951e78de46a00e" # New AMI ID
}

variable "s3_bucket_name" {
  default = "my-terraform-state-bucket-us-west-2" # Existing S3 bucket
}

variable "dynamodb_table_name" {
  default = "terraform-state-lock"
}
