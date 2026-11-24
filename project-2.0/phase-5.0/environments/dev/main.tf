module "network" {
  source = "../../modules/network"
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
  autoscaling_group_name = module.ingress.autoscaling_group_name
  alert_email = var.alert_email
}

module "ingress" {
  source = "../../modules/ingress"

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  docker_image          = var.docker_image
  instance_profile_name = module.roles.iam_instance_profile
}