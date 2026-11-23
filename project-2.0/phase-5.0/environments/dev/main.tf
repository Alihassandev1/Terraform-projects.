module "network" {
  source = "../../modules/network"
}

module "compute" {
  source = "../../modules/compute"
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.subnet_id
  security_group_id    = module.network.security_group_id
  iam_instance_profile = module.roles.iam_instance_profile
  container_docker_image = var.docker_image
  container_name      = var.container_name
}

module "storage" {
  source = "../../modules/storage"
}

module "roles" {
  source = "../../modules/roles"
  secret_arn = module.secret.app_secret_id
}

module "secret" {
  source = "../../modules/secret"
  environment  = var.environment
  database_url = var.database_url
  api_key      = var.api_key
}

module "observability" {
  source = "../../modules/observability"

  environment = var.environment
  instance_id = module.compute.instance_id
  alert_email = var.alert_email
}

module "ingress" {
  source = "../../modules/ingress"

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  docker_image          = var.docker_image
  log_group_name        = var.log_group_name
  instance_profile_name = module.roles.iam_instance_profile_name
}