resource "aws_launch_template" "this" {
  name_prefix   = "selena-asg-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  /*user_data = base64encode(<<EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
    EOF
  )*/
  user_data = base64encode(file("${path.root}/../../scripts/userdata/userdata_asg.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "users-service-instance-asg"
      Environment = var.environment
      Service     = "users-service"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "selena-users-service-asg"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # analog: aws autoscaling start-instance-refresh --auto-scaling-group-name users-service-asg
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 120
    }
    #triggers = ["launch_template"]
  }

  target_group_arns = [
    var.users_alb_tg_arn
  ]

  # so that Terraform waits until the instances are up
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "users-service-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "asg_sg" {
  name        = "selena-asg-sg"
  description = "SG for ASG instances"
  vpc_id      = var.vpc_id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow users-service port (9065)
  ingress {
    from_port   = 9065
    to_port     = 9065
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Amazon Linux 2023 AMI finder
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

# ECS-Optimized Amazon Linux 2 AMI
/*data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}*/

# Target Tracking: keep the average CPU usage of the group around 50%
/*resource "aws_autoscaling_policy" "cpu_tgt_tracking" {
  name                   = "cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}*/
