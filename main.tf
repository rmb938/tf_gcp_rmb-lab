terraform {
  backend "gcs" {
    bucket      = "rmb-lab-tf_gcp"
    credentials = "secrets/decrypted/terraform-state-sa.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}
