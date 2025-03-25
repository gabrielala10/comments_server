resource "google_service_account" "default" {
  account_id   = "service-account-comments2"
  display_name = "Service Account"
  project      = "comments-440520"
}

resource "google_container_cluster" "comments" {
  name     = "comments-cluster"
  location = "us-central1-a"
  project  = "comments-440520"

  remove_default_node_pool = true
  initial_node_count       = 3
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.comments.name
  node_count = 3
  project    = "comments-440520"

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

