module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.1"

  project_id   = var.project_id
  network_name = "vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = var.subnets[0]
      subnet_region = var.region
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