
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
  profile = "terraform-user"

}

resource "aws_instance" "commune_server" {
  ami           = "ami-08e03b36885006906"
  instance_type = "t3.small"

  key_name = "terraform-practice-key"

  subnet_id = "subnet-0e1834a34a0c1f72f"

  vpc_security_group_ids = [
    "sg-09d8faac35782d3f6"
  ]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "commune-server"
    Project = "Commune"
  }
}

output "server_public_ip" {
  description = "Public IP of Commune EC2"
  value       = aws_instance.commune_server.public_ip
}

output "instance_id" {
  value = aws_instance.commune_server.id
}
