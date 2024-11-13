terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
  backend "s3" {
    bucket         = "GS_Semestre2_s3"
    key            = "terraform.tfstate"
    dynamodb_table = "GS_Semestre2_db"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}