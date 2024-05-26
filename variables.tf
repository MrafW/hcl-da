variable "project_id" {
  type = string
  description = "The ID of the Google Cloud project"
}

variable "region" {
  type = string
  description = "The region for deploying resources"
  default = "asia-southeast2"
}

variable "dataset_id" {
  type = string
  description = "The ID of the healthcare dataset"
}

variable "dicom_store_id" {
  type = string
  description = "The ID of the healthcare DICOM store"
}

variable "bucket_id" {
  type = string
  description = "The ID of the Cloud Storage bucket for PNG images"
}

variable "dicom_gcs_uri" {
  type = string
  description = "GCS URI prefix of the DICOM files to import"
  default = "gs://spls/gsp626/LungCT-Diagnosis/R_004/*"
}