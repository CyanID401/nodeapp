module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.1"

  project_id   = var.project_id
  network_name = "vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]
}

resource "google_service_account" "sa" {
  account_id   = "vms-sa"
  display_name = "Custom SA for the VM Instances"
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