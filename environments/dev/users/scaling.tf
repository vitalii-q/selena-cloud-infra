# Launch Template
resource "aws_launch_template" "users_service_lt" {
  name_prefix   = "users-service-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.users_service_instance_type
  key_name      = "selena-aws-key"

  network_interfaces {
    security_groups = [module.ec2.users_sg_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    docker ps || (yum update -y && yum install -y docker && systemctl enable docker && systemctl start docker)
    docker run -d -p ${var.users_service_port}:${var.users_service_port} --restart=always my-docker-repo/users-service:latest
  EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "users_service_asg" {
  name                = "users-service-asg"
  min_size            = var.users_service_min_size
  desired_capacity    = var.users_service_desired_capacity
  max_size            = var.users_service_max_size
  vpc_zone_identifier = [module.vpc.public_subnet_id]

  target_group_arns = [aws_lb_target_group.users_service_tg.arn]

  launch_template {
    id      = aws_launch_template.users_service_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "users-service"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scaling Policy по CPU
resource "aws_autoscaling_policy" "users_cpu_tgt" {
  name                   = "users-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.users_service_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
