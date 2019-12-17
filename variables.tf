variable "scalr_google_project" {}
variable "scalr_google_credentials" {}

variable "cluster_name" {
  type    = string
}

variable "region" {
  description = "The GCE Region to deploy in"
  type        = string
}
