output "bastion_ip" {
  value = local.bastion_ip
}

output "mongo_hosts" {
  value = local.mongo_hosts
}

output "mongo_ips" {
  value = local.mongo_ips
}

output "k8s_cluster_name" {
  value = google_container_cluster.primary.name
}

output "k8s_endpoint" {
  value = google_container_cluster.primary.endpoint
}
