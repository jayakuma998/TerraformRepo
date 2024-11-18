resource "aws_s3_bucket" "public_bucket" {
  bucket = "example-public-bucket"
  acl    = "public-read" # Public access

  tags = {
    Name        = "PublicBucket"
    Environment = "Dev"
  }
}

resource "aws_security_group" "insecure_sg" {
  name        = "insecure-sg"
  description = "Security group with open ingress and egress"
  vpc_id      = "vpc-12345678"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world
  }

  tags = {
    Name = "InsecureSG"
  }
}

resource "aws_instance" "insecure_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = false # Root volume not encrypted
  }

  tags = {
    Name = "InsecureInstance"
  }
}

resource "aws_db_instance" "insecure_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "exampledb"
  username             = "admin"
  password             = "password"
  publicly_accessible  = true # Publicly accessible
  skip_final_snapshot  = true # No final backup on deletion
}
