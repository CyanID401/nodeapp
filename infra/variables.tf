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