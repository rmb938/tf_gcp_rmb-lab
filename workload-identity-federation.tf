resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "Github Actions"
}
