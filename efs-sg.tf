resource "aws_security_group" "efs_sg" {
  vpc_id = aws_vpc.eks.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "EKS-EFS-SG"
  }
}
