variable "cluster_name" {
  type    = string
}

variable "region" {
  description = "The GCE Region to deploy in"
  type        = string
}

variable "instance_type" {}
