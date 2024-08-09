terraform {
  backend "gcs" {
    bucket      = "rmb-lab-tf_gcp"
    credentials = "secrets/decrypted/terraform-state-sa.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.40.0"
    }
  }
}
