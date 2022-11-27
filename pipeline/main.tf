#---pipeline/main.tf----

# Create s3 bucket for pipeline artifacts
resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "codepipeline_artifacts_acl" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id
  acl    = "private"
}

