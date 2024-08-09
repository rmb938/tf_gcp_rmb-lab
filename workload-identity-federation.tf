resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "Github Actions"
}

# https://github.com/rmb938/tf_hashicorp_vault
data "github_repository" "tf_hashicorp_vault" {
  full_name = "rmb938/tf_hashicorp_vault"
}

resource "google_iam_workload_identity_pool_provider" "gha_tf_hashicorp_vault" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha-tf-hashicorp-vault"
  attribute_condition                = "assertion.repository_id == '${data.github_repository.tf_hashicorp_vault.repo_id}'"
  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.aud"           = "assertion.aud"
    "attribute.repository_id" = "assertion.repository_id"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_storage_bucket" "tf_hashicorp_vault" {
  name          = "rmb-lab-tf_hashicorp_vault"
  force_destroy = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_hashicorp_vault" {
  bucket = google_storage_bucket.tf_hashicorp_vault.name
  role   = "roles/storage.objectAdmin"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github-actions.name}/attribute.repository_id/${data.github_repository.tf_hashicorp_vault.repo_id}"
}
