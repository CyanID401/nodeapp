# Initial Setup

```bash
cd infra && terraform apply
```

Set env vars, before running the playbook:
```bash
export MONGO_INITDB_ROOT_USER=root
export MONGO_INITDB_ROOT_PASS=secret
```

Inventory is generated automatically with Terraform and you can execute:
```bash
ansible-playbook -i ansible/inventory.ini ansible/config.yml
```
This will configure MongoDB in a container with replication.