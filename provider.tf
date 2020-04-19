provider "google" {
    credentials = "secrets/decrypted/terraform-sa.json"
    project = "rmb-lab"
}
