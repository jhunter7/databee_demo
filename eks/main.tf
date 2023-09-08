provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "example" {
  name     = "hunter"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.27"

  vpc_config {
    subnet_ids = aws_subnet.example[*].id
  }

  tags = {
    OWNER    = "HUNTER_J"
    CATEGORY = "ENG_ASSESSMENT"
  }
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "hunter-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

  scaling_config {
    desired_size = 4
    max_size     = 6
    min_size     = 3
  }

  instance_types = ["c5.xlarge"] # CPU Optimized instance type
  # key_name       = "hunter" 

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "hunter-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    OWNER    = "HUNTER_J"
    CATEGORY = "ENG_ASSESSMENT"
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "hunter-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    OWNER    = "HUNTER_J"
    CATEGORY = "ENG_ASSESSMENT"
  }
}

resource "aws_launch_template" "example" {
  name_prefix = "hunter"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      OWNER    = "HUNTER_J"
      CATEGORY = "ENG_ASSESSMENT"
    }
  }
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "hunter"
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    OWNER    = "HUNTER_J"
    CATEGORY = "ENG_ASSESSMENT"
  }
}

resource "aws_subnet" "example" {
  count = 2
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_sg"
  description = "Security group for EKS cluster"

  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["196.182.32.48/32"]
  }
}

output "vpc_id" {
  value = aws_vpc.example.id
}
