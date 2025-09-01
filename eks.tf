# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "jethalal"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_private_1a.id,
      aws_subnet.eks_private_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}