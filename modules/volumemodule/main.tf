resource "aws_ebs_volume" "Terraform_Volume" {
  availability_zone = var.availability_zone
  size              = var.size

  tags = var.volume_tag

}

resource "aws_volume_attachment" "attach_volume" {
  device_name = "/dev/sdh"  
  volume_id   = aws_ebs_volume.Terraform_Volume.id
  instance_id = var.instance_id  
}
