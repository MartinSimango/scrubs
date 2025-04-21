resource "aws_s3_bucket" "scrubs_terraform_state" {
  bucket = "scrubs-terraform-state-bucket"

}

resource "aws_s3_bucket_versioning" "scrubs_terraform_state" {
  bucket = aws_s3_bucket.scrubs_terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "scrubs_terraform_state" {
  bucket = aws_s3_bucket.scrubs_terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

