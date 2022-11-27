#---root/main.tf----

module "networking" {
  source                  = "./networking"
  vpc_cidr                = local.vpc_cidr
  public_sn_count         = 2
  max_subnets             = 20
  public_cidrs            = [for i in range(1, 255, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
  map_public_ip_on_launch = true
  availability_zones      = local.availability_zones
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
  desired_capacity       = 2
  max_size               = 3
  min_size               = 2
  vpc_zone_identifier    = module.networking.public_subnets
}

module "pipeline" {
  source      = "./pipeline"
  bucket_name = "cicd-pipeline-artifacts-141511272022"
  compute_type = "BUILD_GENERAL1_SMALL"
  image = "hashicorp/terraform:1.3.5"
  type = "LINUX_CONTAINER"
  dockerhub_credentials = var.dockerhub_credentials
  codestar_connector_credentials = var.codestar_connector_credentials
}
