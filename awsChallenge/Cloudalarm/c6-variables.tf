variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-west-2"  
}

variable "s3_bucket" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "my-terraform-state-bucket-us-west-2"  
}

