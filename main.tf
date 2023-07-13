# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpcs" {
  source = "./module_vpc/"

  vpcs = [
    {
      name               = "VPC1"
      cidr_block         = "10.0.0.0/16"
      subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      availability_zones = ["us-east-1a", "us-east-1b"]
      enable_dns_hostnames = true
    },
    {
      name               = "VPC2"
      cidr_block         = "10.1.0.0/16"
      subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24"]
      availability_zones = ["us-west-2a", "us-west-2b"]
      enable_dns_hostnames = false
    }
  ]
}

