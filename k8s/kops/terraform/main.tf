provider "aws" {
  region = "${var.aws.region}"
}

terraform {
  backend "remote" {}
}

# DNS https://www.terraform.io/docs/providers/aws/r/route53_zone.html
resource "aws_route53_zone" "boilerplate" {
  name = "boilerplate.io"
}

resource "aws_route53_zone" "kops" {
  name = "${var.kops.subdomain}"

  tags = {
    Environment = "kops"
  }
}

resource "aws_route53_record" "kops-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.kops.subdomain}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.kops.name_servers.0}",
    "${aws_route53_zone.kops.name_servers.1}",
    "${aws_route53_zone.kops.name_servers.2}",
    "${aws_route53_zone.kops.name_servers.3}",
  ]
}

# IAM https://kops.sigs.k8s.io/getting_started/aws/#setup-iam-user
resource "aws_iam_group" "kops" {
  name = "${var.kops.iam_group}"
}

resource "aws_iam_group_policy_attachment" "kops_ec2" {
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_r53" {
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_s3" {
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_iam" {
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_vpc" {
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user" "kops" {
  name = "${var.kops.iam_user}"
}

resource "aws_iam_group_membership" "kops" {
  name = "${var.kops.iam_group_membership}"

  users = [
    "${aws_iam_user.kops.name}",
  ]

  group = "${aws_iam_group.kops.name}"
}

resource "aws_iam_access_key" "kops" {
  user = "${aws_iam_user.kops.name}"
}

# S3 Bucket https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
resource "aws_s3_bucket" "kops" {
  bucket        = "${var.kops.aws_bucket}"
  region        = "${var.aws.region}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name        = "kops"
    Environment = "kops"
  }
}
