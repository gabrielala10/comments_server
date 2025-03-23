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

provider "google" {
  project = "comments-440520"
  region = "us-central1-a"
  credentials = file("serviceaccount-key.json")
}