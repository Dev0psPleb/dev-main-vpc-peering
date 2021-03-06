terraform {
  backend "remote" {
    organization = "BrynardSecurity"

    workspaces {
      name = "dev-main-vpc-peering"
    }
  }
}

data "terraform_remote_state" "this" {
  backend = "remote"

  config = {
    organization = "BrynardSecurity"
    workspaces = {
      name = "dev-us-west-2"
    }
  }
}

data "terraform_remote_state" "peer" {
  backend = "remote"

  config = {
    organization = "BrynardSecurity"
    workspaces = {
      name = "dev-us-east-2"
    }
  }
}

variable "aws_peer_access_key" {}
variable "aws_peer_secret_key" {}
variable "aws_this_access_key" {}
variable "aws_this_secret_key" {}

module "vpc-peering_example_multi-account-multi-region" {
  source  = "grem11n/vpc-peering/aws//examples/multi-account-multi-region"
  version = "4.0.1"
  # insert the 6 required variables here

  aws_peer_access_key = var.aws_peer_access_key
  aws_peer_secret_key = var.aws_peer_secret_key

  aws_this_access_key = var.aws_this_access_key
  aws_this_secret_key = var.aws_this_secret_key

  this_vpc_id = data.terraform_remote_state.this.vpc_id
  peer_vpc_id = data.terraform_remote_state.peer.vpc_id

}
