locals {
  bastion_ip  = google_compute_instance.bastion_vm.network_interface[0].access_config[0].nat_ip
  mongo_ips = [for vm in google_compute_instance.mongo_vm : "${vm.network_interface[0].network_ip}"]
  mongo_hosts = [for vm in google_compute_instance.mongo_vm : "${vm.hostname}"]
  mongo_hosts_map = [for vm in google_compute_instance.mongo_vm : {
    "ip": "${vm.network_interface[0].network_ip}",
    "hostname": "${vm.hostname}"
  }]
}