variable "aws" {
  type = "map"

  default = {
    region = ""
  }
}

variable "data" { # TODO: chage to something like aws.vpcs.data
  type = "map"

  default = {
    vpc_id = ""
  }
}

variable "postgresql" {
  type = "map"

  default = {
    engine_version = ""
    instance_class = ""
    allocated_storage = ""
    deletion_protection = ""
    username = ""
    port = ""
    security_group = ""
  }
}

variable "environment" {
  description = "Application or environment name"
}

variable "stage" {
  description = "Staging or Production"
}

variable "multi_az" {
  description = "Enable RDS Multi AZ"
}
