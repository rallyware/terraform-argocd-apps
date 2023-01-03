output "apps" {
  value       = [for app in local.apps : app.name]
  description = "A list of deployed apps"
}
