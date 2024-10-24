provider "aws" {
  region     = "us-east-1"

}

module "security_group" {
  source       = "../modules/securitemodule"
  aws_security = "yasmine-security"
}

module "ec2_instance" {
  source          = "../modules/ec22module"
  instance_type   = "t2.micro"
  key             = "yasmine-key"
  security_group_ids = [module.security_group.id]  
  size = 10
  aws_common_tag = {
     Name = "ec2-yasmine"
  }
  aws_security = module.security_group.aws_security
}

module "volume" {
  source             = "../modules/volumemodule"
  size               = 10
  availability_zone  = "us-east-1a"
  instance_id        = module.ec2_instance.instance_id  
  volume_tag = {
     Name = "yasmine-volume"
  }
}

module "ip" {
  source      = "../modules/ipmodule"
  instance_id = module.ec2_instance.instance_id  
}
