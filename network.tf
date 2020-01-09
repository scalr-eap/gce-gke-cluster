resource "google_compute_network" "cluster_vpc" {
  name    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = "true"
  routing_mode = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name = "${var.cluster_name}-cluster-router"
  network = google_compute_network.cluster_vpc.self_link
}

resource "google_compute_firewall" "all_inbound" {
  name = "${var.cluster_name}-private-fwr"

  network = google_compute_network.cluster_vpc.self_link

  direction   = "INGRESS"

  source_ranges = [
    "0.0.0.0/0"
  ]

  priority = "1000"

  allow {
    protocol = "all"
  }

  allow {
    protocol = "tcp"
    ports = [ "22", "80", "3306"]
  }
}
