resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  force_destroy = true # forced deletion even if files are present

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# autoloud .env files
resource "aws_s3_object" "env_files" {
  for_each = fileset("${path.module}/../../environments/dev/s3_files", "*.env")

  bucket = aws_s3_bucket.this.id
  key    = each.value
  source = "${path.module}/../../environments/dev/s3_files/${each.value}"

  etag = filemd5("${path.module}/../../environments/dev/s3_files/${each.value}")
}