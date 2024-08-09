resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "Github Actions"
}

resource "google_iam_workload_identity_pool_provider" "gha_tf_hashicorp_vault" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha_tf_hashicorp_vault"
  attribute_condition                = "assertion.repository_id == '0'"
  attribute_mapping = {
    "google.subject" = "attribute.repository_id=assertion.repository_id"
  }
}