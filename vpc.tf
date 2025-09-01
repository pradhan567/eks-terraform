# VPC
resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks-igw"
  }
}

# Public Subnet - 1a
resource "aws_subnet" "eks_public_1a" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-1a"
  }
}

# Public Subnet - 1b
resource "aws_subnet" "eks_public_1b" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-1b"
  }
}

# Private Subnet - 1a
resource "aws_subnet" "eks_private_1a" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "eks-private-1a"
  }
}

# Private Subnet - 1b
resource "aws_subnet" "eks_private_1b" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "eks-private-1b"
  }
}

# EIP for NAT Gateway
resource "aws_eip" "eks" {
  domain = "vpc"
}

# NAT Gateway in public subnet (1a)
resource "aws_nat_gateway" "eks" {
  allocation_id = aws_eip.eks.id
  subnet_id     = aws_subnet.eks_public_1a.id

  tags = {
    Name = "eks-nat"
  }
}

# Public Route Table
resource "aws_route_table" "eks_public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }

  tags = {
    Name = "eks-public-rt"
  }
}

# Associate public subnets with public RT
resource "aws_route_table_association" "eks_public_1a" {
  subnet_id      = aws_subnet.eks_public_1a.id
  route_table_id = aws_route_table.eks_public.id
}

resource "aws_route_table_association" "eks_public_1b" {
  subnet_id      = aws_subnet.eks_public_1b.id
  route_table_id = aws_route_table.eks_public.id
}

# Private Route Table
resource "aws_route_table" "eks_private" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks.id
  }

  tags = {
    Name = "eks-private-rt"
  }
}

# Associate private subnets with private RT
resource "aws_route_table_association" "eks_private_1a" {
  subnet_id      = aws_subnet.eks_private_1a.id
  route_table_id = aws_route_table.eks_private.id
}

resource "aws_route_table_association" "eks_private_1b" {
  subnet_id      = aws_subnet.eks_private_1b.id
  route_table_id = aws_route_table.eks_private.id
}
