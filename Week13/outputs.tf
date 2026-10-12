output "admin_password" {
  value       = var.admin_password
  description = "Demonstration of a sensitive output"
  sensitive   = true
}

output "server_summary" {
  description = "Map of server name to its public DNS"
  value = {
    for name, inst in module.web_server.instances :
    name => inst.public_dns
  }
}

output "frontend_servers" {
  description = "Names of frontend servers only"
  value = [
    for name, cfg in var.servers : name
    if cfg.role == "frontend"
  ]
}

output "all_private_ips" {
  description = "Splat over all instances"
  value       = values(module.web_server.instances)[*].private_ip
}
