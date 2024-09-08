variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

# variable "sg_name" {
#   default = "db"
# }


# variable "vpc_id" {
#   default = " "
# }

variable "common_tags" {
  default = {
    Project="expense"
    Environment="dev"
    Terraform=true
  }
}