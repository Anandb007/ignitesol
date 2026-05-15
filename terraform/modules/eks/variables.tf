variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_nodegroup_role_arn" {
  type = string
}
