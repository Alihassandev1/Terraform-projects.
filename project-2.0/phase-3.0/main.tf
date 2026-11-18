module "network" {
  source = "./modules/network"
}

module "compute" {
  source = "./modules/compute"
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.subnet_id
  security_group_id    = module.network.security_group_id
  iam_instance_profile = module.roles.iam_instance_profile
  docker_image        = var.docker_image
  container_name      = var.container_name
}

module "storage" {
  source = "./modules/storage"
}

module "roles" {
  source = "./modules/roles"
}