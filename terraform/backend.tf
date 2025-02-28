terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-us-west-2"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
