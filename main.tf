#---root/main.tf----

module "networking" {
  source                  = "./networking"
  vpc_cidr                = local.vpc_cidr
  public_sn_count         = 2
  max_subnets             = 20
  public_cidrs            = [for i in range(1, 255, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
  map_public_ip_on_launch = true

}