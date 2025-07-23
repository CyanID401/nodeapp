[bastion_group]
bastion ansible_host=${bastion_ip} ansible_user=admin

[mongo_group]
%{ for vm in mongo_hosts_map ~}
${vm.hostname} ansible_host=${vm.ip} ansible_user=admin ansible_ssh_common_args='-o ProxyJump=admin@${bastion_ip}'
%{ endfor ~}