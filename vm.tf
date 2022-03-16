terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("key.json")
  project = "sai-new"
  region  = "us-central1"
  zone    = "us-central1-c"
}


resource "google_compute_instance" "vm1"{
  name="vm1"
  machine_type = "n2-standard-4"
  zone = "us-central1-c"
boot_disk {
  initialize_params{
    image="debian-cloud/debian-9"
  }
}
network_interface {
  network="default"
}
}
