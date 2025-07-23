resource "google_service_account" "sa" {
  account_id   = "vms-sa"
  display_name = "Custom SA for the VM Instances"
}

# Bastion for access to internal resources
resource "google_compute_instance" "bastion_vm" {
  name         = "bastion-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = module.vpc.subnets["${var.region}/subnet-01"].self_link
    access_config {}
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
}

resource "google_compute_instance" "mongo_vm" {
  count        = 3
  name         = "mongo-vm-${count.index + 1}"
  machine_type = var.vm_machine_type
  zone         = "${var.region}-a"

  tags = ["mongodb"]

  hostname = "mongo-${count.index + 1}.db.internal"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = module.vpc.subnets["${var.region}/subnet-01"].self_link
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
}