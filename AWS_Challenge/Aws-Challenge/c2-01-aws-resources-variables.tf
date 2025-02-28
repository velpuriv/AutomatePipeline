variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-west-2"
}

variable "key_pair" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "eks-terraform-key"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "SAP"
}
