resource "google_service_account" "default" {
  account_id   = "service-account-id2"
  display_name = "Service Account"
}

resource "google_container_cluster" "comments" {
  name     = "selecao"
  location = "us-central1-a"

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.comments.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

provider "kubernetes" {
  config_path = "kubeconfig.yaml"
}

resource "kubernetes_namespace" "application" {
  metadata {
    name    = "application"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}