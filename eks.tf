# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "jethalal"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_private_1a.id,
      aws_subnet.eks_private_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

# EFS CSI Driver Addon
resource "aws_eks_addon" "efs_csi" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "aws-efs-csi-driver"

  depends_on = [aws_eks_cluster.eks]
}