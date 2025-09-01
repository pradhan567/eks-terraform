# Define the EFS File System
resource "aws_efs_file_system" "eks_efs" {
  creation_token = "my-efs-filesystem"
  performance_mode = "generalPurpose"

  tags = {
    Name = "EKS-EFS"
  }
}

# Create an EFS Mount Target in a specific subnet
resource "aws_efs_mount_target" "efs_mt" {
  for_each = {
    "ap-south-1a" = aws_subnet.eks_private_1a.id
    "ap-south-1b" = aws_subnet.eks_private_1b.id
  }

  file_system_id  = aws_efs_file_system.eks_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}