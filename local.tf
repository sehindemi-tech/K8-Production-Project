locals {
  name   = "eks-project"
  domain = "lab.demitech.co.uk"
  region = "eu-west-2"

  tags = {
    Environment = "SandBox-Project"
    Project     = "EKS Production App"
    Owner       = "Demi"
  }
}