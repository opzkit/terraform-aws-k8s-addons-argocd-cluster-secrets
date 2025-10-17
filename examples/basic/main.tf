module "secrets" {
  source = "../../"
}

output "secrets" {
  value = module.secrets.addons
}
