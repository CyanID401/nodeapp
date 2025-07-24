variable "gke_num_nodes" {
  default     = 1
  description = "Number of GKE nodes per zone"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = module.vpc.network_self_link
  subnetwork = module.vpc.subnets["${var.region}/subnet-01"].self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }

  deletion_protection = false # For testing purposes
}

# Node Pool
resource "google_service_account" "gke_node_sa" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
}

resource "google_container_node_pool" "primary_nodes" {
  name     = google_container_cluster.primary.name
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_count = var.gke_num_nodes

  node_config {
    machine_type = var.vm_machine_type
    disk_size_gb = 25
    service_account = google_service_account.gke_node_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    labels = {
      env = var.project_id
    }

    tags     = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}