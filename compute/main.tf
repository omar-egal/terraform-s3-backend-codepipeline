#---compute/main.tf---

resource "random_uuid" "instance_suffix" {}

# The Launch Template for the EC2 instances
resource "aws_launch_template" "week24_lt" {
  name                   = "week24-lt"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "instance${substr(random_uuid.instance_suffix.result, 8, 5)}"
    }
  }
}

# Autoscaling group for EC2 instances
resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.desired_capacity # 2
  max_size            = var.max_size         # 3
  min_size            = var.min_size         # 2
  vpc_zone_identifier = var.vpc_zone_identifier
  launch_template {
    id      = aws_launch_template.week24_lt.id
    version = "$Latest"
  }
}