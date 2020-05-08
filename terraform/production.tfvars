environment="boilerplate"

aws = {
  region = "us-east-1"
}

data = {
  vpc_id = "vpc-31354554"
}

stage="production"

multi_az = "true"

postgresql = {
  engine_version = "12"
  instance_class = "db.t2.micro"
  allocated_storage = "30"
  deletion_protection = "true"
  username = "boilerplate"
  port = "5432"
  security_group = "sg-0ba4454feac26d773"
}
