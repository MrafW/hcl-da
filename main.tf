# Enable Healthcare API
resource "google_project_service" "healthcare_api" {
  service = "healthcare.googleapis.com"
}

# Healthcare Dataset
resource "google_healthcare_dataset" "dataset" {
  name     = var.dataset_id
  location = var.region

  iam_member {
    role   = "roles/logging.logWriter"
    member = "serviceAccount:service-${var.project_id}@gcp-sa-healthcare.iam.gserviceaccount.com"
  }
}

# Grant Permissions
resource "google_service_account_iam_member" "storage_object_admin" {
  service_account_id = "serviceAccount:gcp-sa-healthcare.iam.gserviceaccount.com"
  role               = "roles/storage.objectAdmin"
  member             = "serviceAccount:gcp-sa-healthcare.iam.gserviceaccount.com"
}

resource "google_healthcare_dataset_iam_member" "dataset_admin" {
  dataset_id = var.dataset_id
  role        = "roles/healthcare.datasetAdministrator"
  member      = "serviceAccount:gcp-sa-healthcare.iam.gserviceaccount.com"
}

resource "google_healthcare_dicom_store_iam_member" "dicom_editor" {
  dicom_store_id = var.dicom_store_id
  dataset_id     = var.dataset_id
  role            = "roles/healthcare.dicomEditor"
  member          = "serviceAccount:gcp-sa-healthcare.iam.gserviceaccount.com"
}

#DICOM Store
resource "google_healthcare_dicom_store" "dicom_store" {
  dataset = google_healthcare_dataset.dataset.id
  name     = var.dicom_store_id # Use the variable for consistency
}

# Grant DICOM Import Permissions
resource "google_healthcare_dicom_store_iam_member" "gcs_service_account" {
  dicom_store_id = google_healthcare_dicom_store.dicom_store.id
  role           = "roles/healthcare.dicomImportJobCreator"
  member         = "serviceAccount:${google_project_service_identity.healthcare_service_account.email}"
}

resource "google_healthcare_dicom_store_iam_member" "compute_engine_default_service_account" {
  dicom_store_id = google_healthcare_dicom_store.dicom_store.id
  role           = "roles/healthcare.dicomImportJobRunner"
  member         = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

# Import DICOM Datasets using dedicated resource
resource "google_healthcare_dicom_store_import" "import_job" {
  dicom_store = google_healthcare_dicom_store.dicom_store.id

  gcs_source {
    uri_prefix = var.dicom_gcs_uri // Use the variable for the GCS path
  }
}