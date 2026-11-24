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
  environment_  = var.environment_
  database_url_ = var.database_url_
  api_key_      = var.api_key_
}

module "observability" {
  source = "../../modules/observability"

  environment = var.environment_
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