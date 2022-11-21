terraform {
  backend "s3" {
    bucket = "terraform-backend-dev-11212022"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}