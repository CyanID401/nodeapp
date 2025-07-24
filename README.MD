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


Build & Push and image to the newly created private repo:
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