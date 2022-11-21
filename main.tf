#---root/main.tf----

module "networking" {
  source                  = "./networking"
  vpc_cidr                = local.vpc_cidr
  public_sn_count         = 2
  max_subnets             = 20
  public_cidrs            = [for i in range(1, 255, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
  map_public_ip_on_launch = true
}

module "security" {
  source          = "./security"
  vpc_id          = module.networking.vpc_id
  security_groups = local.security_groups
}

module "compute" {
  source                 = "./compute"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  key_name               = "luit_key"
  vpc_security_group_ids = module.security.security_group_id[0]
} 