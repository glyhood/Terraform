module "eks_devops_test" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "19.7.0"
  cluster_name              = var.cluster_name
  cluster_version           = "1.24"
  vpc_id                    = data.aws_vpc.vdldev_dev1.id
  subnet_ids                = ["subnet-067214a1dc427fba5", "subnet-0b1bac718ee9d5ac9"]
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::1234:role/AWSReservedSSO_AWSAdministratorAccess_3c34d318d31928e6"
      username = "EVO_Sandbox_Admin"
      groups   = ["system:masters"]
    }
  ]

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.9.3-eksbuild.2"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.24.9-eksbuild.1"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.12.2-eksbuild.1"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.16.0-eksbuild.1"
    }
    adot = {
      resolve_conflicts = "OVERWRITE"
      addon_version = "v0.66.0-eksbuild.1"
    }
  }

  eks_managed_node_group_defaults = {
    instance_types = ["m5a.xlarge"]
    subnet_ids = ["subnet-067214a1dc427fba5"]
    pre_bootstrap_user_data = <<-EOT
    
    EOT
  }

  eks_managed_node_groups = {
    node-group-1 = {
      name         = "node-group-1"
      min_size     = 1
      max_size     = 10
      desired_size = 5
      labels = {
        "environment" = var.environment
        "managed_by"  = "terraform"
      }
      tags = {
        "Environment"                                   = var.environment
        "Terraform"                                     = "true"
        "Owner"                                         = "DevOps"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"             = "true"
      }
    }
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_cluster_control_plane = {
      description                   = "From Control plane security group"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

