resource "aws_secretsmanager_secret" "app_secret" {
  name        = "${var.environment_}/linkedops"
  description = "LinkedOps application secrets"
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string   = jsonencode({
    DATABASE_URL_ = var.database_url_
    API_KEY_      = var.api_key_
    secret_arn_   = aws_secretsmanager_secret.app_secret.arn
  })
}