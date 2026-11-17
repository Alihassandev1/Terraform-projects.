module "network" {
  source = "./modules/network"
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_id
}

module "storage" {
  source = "./modules/storage"
}

module "roles" {
  source = "./modules/roles"
}