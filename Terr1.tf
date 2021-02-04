#----------------------------------------------------------
#--------- Build Web Server during Bootstrap
#----------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0a6dc7529cd559185"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  user_data              = file("user_data1.sh")
  key_name="Frankfurt-key" # Ec2 Dashboard->Network & Security->Key Pairs->Name of Key in region = "eu-central-1"

  tags = {Name = "Web Server Build by Terraform"}
}

resource "aws_security_group" "web_server" {
  name        = "WebServer Security Group"
  description = "SecurityGroup"

  dynamic "ingress" {
    for_each      = ["80", "443","22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {Name = "Web Server SecurityGroup"}
}
