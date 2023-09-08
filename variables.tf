# Define input variables for the module
variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "hunter"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  default     = "1.27"
}

variable "min_nodes" {
  description = "Minimum number of worker nodes"
  default     = 3
}

variable "max_nodes" {
  description = "Maximum number of worker nodes"
  default     = 6
}

variable "desired_nodes" {
  description = "Desired number of worker nodes"
  default     = 4
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "c5.xlarge"
}

variable "eks_optimized_ami" {
  description = "ID of the EKS-optimized Amazon Linux 2 AMI"
  default     = "ami-0f5b0ccc76f7be5da" 
}

variable "vpc_id" {
  description = "ID of the VPC"
  default     = "vpc-078f9a4a9bb140398" # VPC ID of my lab/test AWS account
}

variable "subnet_cidr" {
  description = "CIDR block for subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"] 
}

variable "namespace" {
  description = "Namespace for Kubernetes"
  default     = "hunter"
}

variable "allowed_cidr_block" {
  description = "Allowed CIDR block for network policy"
  default     = "196.182.32.48/32"
}


module "eks_cluster" {
  source = "./eks" # Replace with the actual path to your module

  # cluster_name          = var.cluster_name
  # kubernetes_version    = var.kubernetes_version
  # min_nodes             = var.min_nodes
  # max_nodes             = var.max_nodes
  # desired_nodes         = var.desired_nodes
  # node_instance_type    = var.node_instance_type
  # eks_optimized_ami     = var.eks_optimized_ami
  # vpc_id                = var.vpc_id
  # subnet_cidr           = var.subnet_cidr
  # namespace             = var.namespace
  # allowed_cidr_block    = var.allowed_cidr_block
}
