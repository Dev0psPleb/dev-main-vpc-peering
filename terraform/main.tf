terraform {
  backend "remote" {
    organization = "BrynardSecurity"

    workspaces {
      name = "dev-main-vpc-peering"
    }
  }
}

data "terraform_remote_state" "dev-us-west-2" {
  backend = "remote"

  config = {
    organization = "BrynardSecurity"
    workspaces = {
      name = "dev-us-west-2"
    }
  }
}

data "terraform_remote_state" "dev-us-east-2" {
  backend = "remote"

  config = {
    organization = "BrynardSecurity"
    workspaces = {
      name = "dev-us-east-2"
    }
  }
}

provider "aws" {
  alias  = "dev"
  region = "us-west-2"
}

provider "aws" {
  alias  = "main"
  region = "us-east-2"
}

locals {
  tags = {
    Environment = dev
    Environment = main
    Name        = "dev-main-vpc-peering"
  }
}

module "vpc-peering_example_multi-account-multi-region" {
  source  = "grem11n/vpc-peering/aws//examples/multi-account-multi-region"
  version = "4.0.1"
  # insert the 6 required variables here

  providers = {
    aws.this = aws.this
    aws.peer = aws.peer
  }

  this_vpc_id = data.terraform_remote_state.vpc.vpc_id
  peer_vpc_id = data.terraform_remote_state.vpc.vpc_id

  auto_accept_peering = true

  tags = {
    Environment = "dev"
    Account     = "devops-test"
    PeerAccount = "main"
  }

}
