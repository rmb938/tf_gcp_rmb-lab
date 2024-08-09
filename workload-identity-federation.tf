resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "Github Actions"
}

# https://github.com/rmb938/tf_hashicorp_vault
resource "google_iam_workload_identity_pool_provider" "gha_tf_hashicorp_vault" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha-tf-hashicorp-vault"
  attribute_condition                = "assertion.repository_id == '840079927'"
  attribute_mapping = {
    "google.subject" = "attribute.repository_id=assertion.repository_id"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
