output "addons" {
  value = {
    content = templatefile("${path.module}/addon_content.tpl", {
      secrets = [for s in data.aws_secretsmanager_secret_version.secret_version : jsondecode(s.secret_string)]
    })
    version = local.version
    name    = "argocd-cluster-secrets"
  }
}
