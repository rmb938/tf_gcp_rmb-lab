terraform {
  backend "gcs" {
    bucket  = "rmb-lab-tf_gcp"
    credentials = "secrets/decrypted/terraform-state-sa.json"
  }
}
