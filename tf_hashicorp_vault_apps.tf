# https://github.com/rmb938/tf_hashicorp_vault_apps
data "github_repository" "tf_hashicorp_vault_apps" {
  full_name = "rmb938/tf_hashicorp_vault_apps"
}

resource "google_iam_workload_identity_pool_provider" "gha_tf_hashicorp_vault_apps" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha-tf-hashicorp-vault-apps"
  display_name                       = "gha-tf-hashicorp-vault-apps"
  attribute_condition                = "assertion.repository_id == '${data.github_repository.tf_hashicorp_vault_apps.repo_id}'"
  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.aud"           = "assertion.aud"
    "attribute.repository_id" = "assertion.repository_id"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_storage_bucket" "tf_hashicorp_vault_apps" {
  name          = "rmb-lab-tf_hashicorp_vault_apps"
  force_destroy = true

  uniform_bucket_level_access = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_hashicorp_vault_apps" {
  bucket = google_storage_bucket.tf_hashicorp_vault_apps.name
  role   = "roles/storage.objectAdmin"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github-actions.name}/attribute.repository_id/${data.github_repository.tf_hashicorp_vault_apps.repo_id}"
}
