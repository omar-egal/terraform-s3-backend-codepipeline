variable "region" {
  type    = string
  default = "us-east-1"
}


variable "codestar_connector_credentials" {
  type      = string
  sensitive = true
}