output "bucket_name" {
  value = var.bucket_name != "" ? var.bucket_name : aws_s3_bucket.this[0].id
}
