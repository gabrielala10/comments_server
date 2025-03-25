terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.9.0"
    }
  }
  backend "gcs" {
    bucket  = "gpc-comments-state"
    prefix  = "terraform/state"
  }
}
