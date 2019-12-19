terraform {
  backend "remote" {
    hostname     = "my.scalr.com"
    organization = "org-sfgari365m7sck0"
    workspaces {
      name         = "gce_gke_cluster"
    }
  }
}

provider "google" {
    region      = var.region
}

resource "google_container_cluster" "this" {
  name     = "${var.cluster_name}"
  location = var.region

  network = google_compute_network.cluster_vpc.self_link

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "this_nodes" {
  name       = "${var.cluster_name}-nodes"
  location = var.region
  cluster    = google_container_cluster.this.name
  node_count = 1

  node_config {
    preemptible  = true
#    machine_type = var.instance_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/sqlservice.admin"
    ]
  }
}

output "cluster_endpoint" {
  value       = "${google_container_cluster.this.endpoint}"
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {
}

output "kubectl-config" {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region} --project ${data.google_client_config.default.project}"
  }
