module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.1"

  project_id   = var.project_id
  network_name = "vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name                = "subnet-01"
      subnet_ip                  = var.subnets[0]
      subnet_region              = var.region
      subnet_private_access      = true
    }
  ]

  ingress_rules = [
    {
      name      = "allow-icmp"
      direction = "INGRESS"
      allow = [{
        protocol = "icmp"
      }]
      source_ranges = ["0.0.0.0/0"]
    },
    {
      name      = "allow-ssh"
      direction = "INGRESS"
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["mongodb"]
    },
    {
      name      = "allow-mongo"
      direction = "INGRESS"
      allow = [{
        protocol = "tcp"
        ports    = ["27017"]
      }]
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["mongodb"]
    }
  ]
}

# DNS
resource "google_dns_managed_zone" "internal_zone" {
  name        = "internal-zone"
  dns_name    = "db.internal."
  description = "Private DNS zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc.network_self_link
    }
  }
}

resource "google_dns_record_set" "mongo_a_records" {
  for_each = {
    for vm in google_compute_instance.mongo_vm :
    vm.name => {
      name = "${vm.hostname}.${google_dns_managed_zone.internal_zone.dns_name}"
      ip   = vm.network_interface[0].network_ip
    }
  }

  name         = each.value.name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.internal_zone.name
  rrdatas      = [each.value.ip]
}