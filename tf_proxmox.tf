# https://github.com/rmb938/tf_proxmox
data "github_repository" "tf_proxmox" {
  full_name = "rmb938/tf_proxmox"
}

resource "google_iam_workload_identity_pool_provider" "gha_tf_proxmox" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha-tf-proxmox"
  display_name                       = "gha-tf-proxmox"
  attribute_condition                = "assertion.repository_id == '${data.github_repository.tf_proxmox.repo_id}'"
  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.aud"           = "assertion.aud"
    "attribute.repository_id" = "assertion.repository_id"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_storage_bucket" "tf_proxmox" {
  name          = "rmb-lab-tf_proxmox"
  force_destroy = true

  uniform_bucket_level_access = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_proxmox" {
  bucket = google_storage_bucket.tf_proxmox.name
  role   = "roles/storage.objectAdmin"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github-actions.name}/attribute.repository_id/${data.github_repository.tf_proxmox.repo_id}"
}
