output "mongo_hosts" {
  value = [for host in google_compute_instance.mongo_vm :
    "${host.hostname}"
  ]
}