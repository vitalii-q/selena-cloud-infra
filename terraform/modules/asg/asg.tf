resource "aws_launch_template" "this" {
  name_prefix   = "selena-asg-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.sg_ids

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(templatefile(var.user_data_file, {
    db_host = var.db_host
  }))

  block_device_mappings {        # EBS
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_ebs
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
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

  target_group_arns = var.alb_tg_arn != null ? [var.alb_tg_arn] : []

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
