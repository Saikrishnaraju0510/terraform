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
  project = "modular-asset-332406"
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "example_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = "demo-py@modular-asset-332406.iam.gserviceaccount.com"
  }

  access {
    role   = "READER"
    domain = "hashicorp.com"
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}

resource "google_bigquery_table" "cust_data"{
  dataset_id="example_dataset"
  table_id = "cust_data"

  external_data_configuration {
    autodetect=true
    source_format="CSV"
    csv_options {
      quote = ""
      field_delimiter = ","
      skip_leading_rows=1
    }

    
    source_uris=["gs://us-central1-c1-dea909ea-bucket/supermarket_sales.csv"]
  }
}

resource "google_bigquery_table" "view"{
  dataset_id="example_dataset"
  table_id = "view2"
  project = "modular-asset-332406"
  view {
    query =  "SELECT * FROM `modular-asset-332406.example_dataset.cust_data` WHERE Quantity>4"
    use_legacy_sql = false
  }
  lifecycle {
    ignore_changes = [
      encryption_configuration
    ]
  }
}

resource "google_storage_bucket_object" "picture" {
  name   = "butterfly01"
  source = "C:/Users/gowth/learn-terraform-gcp/supermarket_sales.csv"
  bucket = "sai_1999"
}
