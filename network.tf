resource "google_compute_network" "cluster_vpc" {
  name    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = "true"
  routing_mode = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name = "${var.cluster_name}-cluster-router"
  network = google_compute_network.cluster_vpc.self_link
}
