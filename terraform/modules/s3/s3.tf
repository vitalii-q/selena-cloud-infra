resource "aws_s3_bucket" "this" {
  count = var.bucket_name == "" ? 1 : 0    # create only if the name is not specified

  bucket = var.bucket_name

  force_destroy = true # forced deletion even if files are present

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket   = var.bucket_name != "" ? var.bucket_name : aws_s3_bucket.this[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# autoloud .env files
resource "aws_s3_object" "env_files" {
  for_each = fileset("${path.module}/../../environments/dev/s3_files", "*.env*")

  bucket = var.bucket_name != "" ? var.bucket_name : aws_s3_bucket.this[0].id
  key    = each.value
  source = "${path.module}/../../environments/dev/s3_files/${each.value}"

  etag   = filemd5("${path.module}/../../environments/dev/s3_files/${each.value}")
}