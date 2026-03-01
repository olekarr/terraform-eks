# Allows EC2 instances (EKS worker nodes) to assume the node IAM role
data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role used by worker nodes to interact with EKS and required AWS services
resource "aws_iam_role" "node" {
  name               = "${var.name}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
  tags               = var.tags
}

# Grants worker nodes permissions required to join the cluster and function as nodes
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Grants worker nodes permissions required by the VPC CNI plugin for pod networking
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Grants worker nodes read-only access to pull images from ECR
resource "aws_iam_role_policy_attachment" "container_registry" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Creates a managed EKS node group with the requested instance type and scaling settings
resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name}-nodegroup"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  instance_types = var.instance_types
  disk_size      = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.container_registry
  ]
}