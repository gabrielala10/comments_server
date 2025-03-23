resource "google_storage_bucket" "comments_bucket" {
  name = gcp_comments_bucket
  location = "US"
  force_destroy = true
  public_access_prevention = "enforced"
}