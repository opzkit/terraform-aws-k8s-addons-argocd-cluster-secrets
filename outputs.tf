output "addons" {
  value = [{
    content = templatefile("${path.module}/addon_content.tpl", {
      secrets = { for s in data.aws_secretsmanager_secret.argocd_cluster_secrets : basename(s.name) => s.tags }
    })
    version = local.version
    name    = "argocd-cluster-secrets"
  }]
}
