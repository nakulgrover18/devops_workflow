terraform {
  backend "s3" {
    bucket         = var.bucket
    key            = var.key
    region         = var.region
    encrypt        = var.encrypt
    dynamodb_table = var.dynamodb_table
  }
}

module "s3" {
  source     = "./modules/s3"
  bucket_name = var.bucket_name
}


module "ec2" {
  source              = "./modules/ec2"
  ami_id              = var.ami_id
  instance_type       = "t2.micro"
  key_name            = var.key_name
  security_group_id   = module.sg_web.security_group_id
}

module "alb" {
  source            = "./modules/alb"
  security_group_id = module.sg_alb.security_group_id
  subnet_ids        = var.subnet_ids
  vpc_id            = var.vpc_id                    
  instance_ids      = module.ec2.instance_ids
}
module "sg_web" {
  source = "./modules/sg"

  security_group_name        = "web-sg"
  security_group_description = "Allow HTTP inbound traffic"
  vpc_id                     = var.vpc_id

}

module "sg_alb" {
  source = "./modules/sg"

  security_group_name        = "alb-sg"
  security_group_description = "Allow HTTP inbound traffic for ALB"
  vpc_id                     = var.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}