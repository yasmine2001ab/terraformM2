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
  public_key = file("/home/yasmine/.ssh/id_rsa.pub") #Remplacer par le chemin de votre ssh publique 
}

resource "aws_instance" "yasmine" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.yasmine_key.key_name
  tags                   = var.aws_common_tag
  vpc_security_group_ids = var.security_group_ids

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("yasmine.pem") #Remplacer par votre ssh priver
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
      "echo ${self.public_ip} > ip_ec2.txt"
    ]
  }

  
  root_block_device {
    volume_size = var.size
  }
}

output "public_ip" {
  value = aws_instance.yasmine.public_ip
}
output "instance_id" {
  value = aws_instance.yasmine.id
}
