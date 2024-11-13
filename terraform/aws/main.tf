terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
  backend "s3" {
    bucket         = "gs-semestre2-s3"
    key            = "terraform.tfstate"
    dynamodb_table = "gs-semestre2-db"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}