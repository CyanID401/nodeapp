# Overview
The project contains Terraform code with which you can provision the following GCP infra:
- VPC
- 1 Bastion VM
- 3 VMs for MongoDB (initialize with Ansible)
- Artifact Registry for our app image (build & push with Ansible)
- GKE Cluster and Nodes

# Initial Setup

Provision the infrastructure:
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
This will configure MongoDB in a container in each VM and setup replication for them.


Build & push an image of the nodeapp to the newly created private repo:
```bash
export REPO_URL=$(terraform output -raw artifact_repo_name)
export IMAGE_TAG="1.0"
ansible-playbook ansible/image-push.yml
```

# Deploy to GKE

Get the kube config:
```
gcloud container clusters get-credentials nodeapp-infra-466619-gke --zone europe-north2
```
And run the deployment:
```bash
export MONGO_HOSTS=$(terraform output -json mongo_hosts)
envsubst < ../k8s/deployment.yml | kubectl apply -f -
```