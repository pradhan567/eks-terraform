# EFS for shared Jenkins filesystem
resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

  tags = {
    Name = "jenkins-efs"
  }
}

# Mount targets for EFS in private subnets
resource "aws_efs_mount_target" "jenkins_1a" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.eks_private_1a.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "jenkins_1b" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.eks_private_1b.id
  security_groups = [aws_security_group.efs.id]
}

# Security group for EFS
resource "aws_security_group" "efs" {
  name   = "efs-sg"
  vpc_id = aws_vpc.eks.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}

# Output EFS ID for use in Kubernetes YAML
output "efs_id" {
  value = aws_efs_file_system.jenkins.id
}