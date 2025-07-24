variable "project_id" {
  description = "The ID of the Google Cloud project where resources will be created."
  type        = string
  default     = "nodeapp-infra-466619"
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  default     = "europe-north2"
}

variable "vm_machine_type" {
  description = "The machine type for the VM instances."
  type        = string
  default     = "e2-medium"
}

variable "ssh_user" {
  description = "The username for SSH access to the VM instances."
  type        = string
  default     = "admin"
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key file for VM access."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
