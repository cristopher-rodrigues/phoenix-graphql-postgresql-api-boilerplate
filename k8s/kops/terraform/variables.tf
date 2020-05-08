variable "aws" {
  type = "map"

  default = {
    region = ""
  }
}

variable "kops" {
  type = "map"

  default = {
    iam_group = ""
    iam_user = ""
    iam_group_membership = ""
    aws_bucket = ""
    subdomain = ""
  }
}
