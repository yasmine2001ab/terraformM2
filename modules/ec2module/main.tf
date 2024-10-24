data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_key_pair" "yasmine_key" {
  key_name   = var.key
  public_key = file("/home/yasmine/.ssh/id_rsa.pub")
}


resource "aws_security_group" "allow_http_https" {
  name        = var.aws_security
  description = "Security group to allow HTTP, HTTPS, and SSH traffic"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "yasmine" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.yasmine_key.key_name
  tags          = var.aws_common_tag
  vpc_security_group_ids = [aws_security_group.allow_http_https.id]

  connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = file("yasmine.pem")
     host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.yasmine.id
  domain   = "vpc"
}
