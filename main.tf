data "aws_secretsmanager_secrets" "argocd_cluster_secrets" {
  filter {
    name   = "name"
    values = ["argocd/clusters/"]
  }
}

data "aws_secretsmanager_secret" "argocd_cluster_secrets" {
  for_each = { for k in data.aws_secretsmanager_secrets.argocd_cluster_secrets.names : k => k }
  name     = each.key
}
