data "aws_secretsmanager_secrets" "argocd_cluster_secrets" {
  filter {
    name   = "name"
    values = ["argocd/clusters/"]
  }
}

data "aws_secretsmanager_secret_version" "secret_version" {
  for_each  = data.aws_secretsmanager_secrets.argocd_cluster_secrets.names
  secret_id = each.key
}
