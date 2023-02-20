provider "aws" {
  region = var.region
}

data "aws_vpc" "vdldev_dev1" {
  id = "vpc-01fa1640a18310e85"
}

data "aws_subnets" "vdldev_dev1_az1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vdldev_dev1.id]
  }
}

provider "kubernetes" {
  host                   = module.eks_devops_test.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_devops_test.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", module.eks_devops_test.cluster_name]
  }
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

provider "helm" {
  kubernetes {
    host                   = module.eks_devops_test.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_devops_test.eks_devops_test.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_devops_test.cluster_name]
      command     = "aws"
    }
  }
}
