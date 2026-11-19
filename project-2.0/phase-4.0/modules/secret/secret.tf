resource "aws_secretsmanager_secret" "app_secret" {
  name        = "${var.environment}/linkedops"
  description = "LinkedOps application secrets"
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string = jsonencode({
    DATABASE_URL = var.database_url
    API_KEY      = var.api_key
    secret_arn   = aws_secretsmanager_secret.app_secret.arn
  })
}