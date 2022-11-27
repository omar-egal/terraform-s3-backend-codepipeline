variable "region" {
  type    = string
  default = "us-east-1"
}

variable "dockerhub_credentials" {
  type = string
  sensitive = true
}

variable "codestar_connector_credentials" {
  type = string
  sensitive = true
}