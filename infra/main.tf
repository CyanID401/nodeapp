resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.ini"
  content = templatefile("${path.module}/ansible/inventory.tpl", {
    bastion_ip      = local.bastion_ip
    mongo_hosts_map = local.mongo_hosts_map
  })
}

resource "google_artifact_registry_repository" "artifact_repo" {
  provider = google
  location = var.region
  repository_id = "images-repo"
  description = "Docker artifact repository for GKE private images"
  format = "DOCKER"
  mode = "STANDARD_REPOSITORY"
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.artifact_repo.repository_id

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.gke_node_sa.email}"
}