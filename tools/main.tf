data "aws_eks_cluster_auth" "eks_devops_test" {
  name = var.cluster_name
}

data "aws_eks_cluster" "eks_devops_test" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_devops_test.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_devops_test.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_devops_test.name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_devops_test.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_devops_test.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_devops_test.name]
    command     = "aws"
  }
}
