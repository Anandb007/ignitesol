module "vpc" {
  source       = "../../modules/vpc"
  cluster_name = var.cluster_name #new line

  project_name = "ignitesol"
  environment  = "dev"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

###ECR MODULE
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "sample-test"
}

###IAM MODULE
module "iam" {
  source = "../../modules/iam"

  project_name = "ignitesol"
}

###EKS
module "eks" {
  source = "../../modules/eks"

  project_name = "ignitesol"
  environment  = "dev"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  eks_cluster_role_arn   = module.iam.eks_cluster_role_arn
  eks_nodegroup_role_arn = module.iam.eks_nodegroup_role_arn
}
