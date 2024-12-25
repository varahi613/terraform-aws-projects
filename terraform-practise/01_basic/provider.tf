terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
     aws = {
      source = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}