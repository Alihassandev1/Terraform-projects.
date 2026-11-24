resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-bucket-2026.bucket.io"
  tags = {
    Name = "tf_bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "imported_bucket" {
  bucket = "amzn-first-s3-bucket.io"
  tags = {
    Name = "imported_bucket"
    Environment = "dev"
    Import = "true"
  }
}
