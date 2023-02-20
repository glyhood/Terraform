variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type    = string
  default = "devops-test"
}

variable "cluster_name" {
  type    = string
  default = "eks_devops_test"
}