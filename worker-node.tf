# Launch Template for Worker Nodes
resource "aws_launch_template" "eks_workers" {
  name_prefix   = "eks-workers"
  image_id      = "ami-07802869d4ef48dbe"
  instance_type = "t3.medium"

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_worker_profile.name
  }
}

resource "aws_iam_instance_profile" "eks_worker_profile" {
  name = "eks-worker-profile"
  role = aws_iam_role.eks_worker_role.name
}

# Self-managed Auto Scaling Group for Workers
resource "aws_autoscaling_group" "eks_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.eks_private_1a.id, aws_subnet.eks_private_1b.id]

  launch_template {
    id      = aws_launch_template.eks_workers.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.eks.name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
