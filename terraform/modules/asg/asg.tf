resource "aws_launch_template" "this" {
  name_prefix   = "selena-asg-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(file(var.user_data_file))

  block_device_mappings {        # EBS
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 5
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.service_name}-service-instance-asg"
      Environment = var.environment
      Service     = "${var.service_name}-service"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "selena-${var.service_name}-service-asg"
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

    #triggers = ["launch_template"]   # restart instances when updating aws_launch_template
  }

  target_group_arns = [
    var.alb_tg_arn
  ]

  # so that Terraform waits until the instances are up
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.service_name}-service-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "asg_sg" {
  name        = "selena-${var.service_name}-asg-sg"
  description = "SG for ${var.service_name}-service ASG instances"
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

  # Allow users-service port (var.service_port)
  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
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