locals {
  eks_cluster_name = get_env("EKS_CLUSTER_NAME")
}

# Generate an EKS provider block
generate "provider_eks" {
  path      = "provider_eks.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${local.eks_cluster_name}"
}

data "aws_eks_cluster" "cluster" {
  name = "${local.eks_cluster_name}"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}
EOF
}
