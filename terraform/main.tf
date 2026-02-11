terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.10.0.0/20"
}

# GKE Cluster (Regional for HA)
resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = 2

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Enable GKE Ingress Controller
  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  # Auto-scaling
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum      = 2
      maximum      = 6
    }
    resource_limits {
      resource_type = "memory"
      minimum      = 4
      maximum      = 12
    }
  }

  # Security hardening
  enable_shielded_nodes = true
  enable_private_nodes  = false # Public endpoint for simplicity
  master_authorized_networks_config {}
}
