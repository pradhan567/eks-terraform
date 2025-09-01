resource "aws_eks_node_group" "managed_workers" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "managed-workers"
  node_role_arn   = aws_iam_role.eks_worker_role.arn

  subnet_ids = [
    aws_subnet.eks_private_1a.id,
    aws_subnet.eks_private_1b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  ami_type       = "BOTTLEROCKET_x86_64"

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks.name}" = "owned"
  }
}
