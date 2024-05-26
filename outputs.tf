output "dataset_id" {
  value = google_healthcare_dataset.default.id
}

output "datastore_id" {
  value = google_healthcare_dicom_store.default.id
}