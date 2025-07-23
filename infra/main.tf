resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.ini"
  content = templatefile("${path.module}/ansible/inventory.tpl", {
    bastion_ip         = local.bastion_ip
    mongo_hosts_map    = local.mongo_hosts_map
  })
}