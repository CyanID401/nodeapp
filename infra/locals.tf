locals {
  bastion_ip  = google_compute_instance.bastion_vm.network_interface[0].access_config[0].nat_ip
  mongo_ips   = [for vm in google_compute_instance.mongo_vm : "${vm.network_interface[0].network_ip}"]
  mongo_hosts = [for vm in google_compute_instance.mongo_vm : "${vm.hostname}"]
  mongo_hosts_map = [for vm in google_compute_instance.mongo_vm : {
    "ip" : "${vm.network_interface[0].network_ip}",
    "hostname" : "${vm.hostname}"
  }]

  artifact_repo_name = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.artifact_repo.repository_id}"
}