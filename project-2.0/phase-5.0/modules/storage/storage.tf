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
