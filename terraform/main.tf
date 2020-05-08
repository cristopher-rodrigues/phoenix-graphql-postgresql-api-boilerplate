provider "aws" {
  region = "${var.aws.region}"
}

terraform {
  backend "remote" {}
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

## DATA
### VPC Data Source
data "aws_vpc" "selected" {
  id = "${var.data.vpc_id}"
}

### Get data subnet ids
data "aws_subnet_ids" "data" {
  vpc_id    = "${var.data.vpc_id}"
}

## MODULES
### Redis (TODO)

### Postgres RDS
module "boilerplate_postgresql_rds" {
  source = "terraform-aws-modules/rds/aws"
  version = "2.5.0"
  identifier = "${var.environment}-${var.stage}"

  engine            = "postgres"
  engine_version    = "${var.postgresql.engine_version}"
  instance_class    = "${var.postgresql.instance_class}"
  allocated_storage = "${var.postgresql.allocated_storage}"
  deletion_protection = "${var.postgresql.deletion_protection}"

  name     = "${var.environment}_${var.stage}"
  username = "${var.postgresql.username}"
  password = "${random_password.password.result}" # get the value on the output
  port     = "${var.postgresql.port}"
  multi_az = "${var.multi_az}"

  vpc_security_group_ids = ["${var.postgresql.security_group}"]

  backup_retention_period = "3"
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  tags = {
    Creation-Tool       = "terraform"
    Environment = "${var.stage}"
  }

  # DB subnet group
  subnet_ids = "${data.aws_subnet_ids.data.ids}"

  # DB parameter group
  family = "postgres11"
}
