resource "google_storage_bucket_acl" "gcs-data-lake-landing-acl" {
  bucket = google_storage_bucket.gcs-data-lake-landing.name
  role_entity = [
    "OWNER:${local.unique_id}",
    "READER:${local.unique_id}",
  ]
}

resource "google_storage_bucket_acl" "gcs-data-lake-sensitive-acl" {
  bucket = google_storage_bucket.gcs-data-lake-sensitive.name
  role_entity = [
    "OWNER:${local.unique_id}",
    "READER:${local.unique_id}",
  ]
}

resource "google_storage_bucket_acl" "gcs-data-lake-work-acl" {
  bucket = google_storage_bucket.gcs-data-lake-work.name
  role_entity = [
    "OWNER:${local.unique_id}",
    "WRITER:${local.unique_id}",
  ]
}

resource "google_storage_bucket_acl" "gcs-data-lake-backup-acl" {
  bucket = google_storage_bucket.gcs-data-lake-backup.name
  role_entity = [
    "OWNER:${local.unique_id}",
    "READER:${local.unique_id}",
  ]
}
