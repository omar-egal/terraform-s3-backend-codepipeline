#---compute/main.tf---

# The Launch Template for the EC2 instances
resource "aws_launch_template" "week24_lt" {
  name                   = "bastion_host_lt"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "instance"
    }
  }
}