resource "aws_launch_template" "alt_blue" {
  name          = var.template_blue
  image_id      = "ami-042d7899818bea126"
  instance_type = "t3.micro"

  network_interfaces {
    delete_on_termination = true
    security_groups = [
      data.aws_security_group.sg_ssh.id, data.aws_security_group.sg_http.id
    ]
  }

  placement {
    availability_zone = "eu-west-1"
  }

  user_data = filebase64("${path.module}/script_blue.sh")
}
resource "aws_launch_template" "alt_green" {
  name          = var.template_green
  image_id      = "ami-042d7899818bea126"
  instance_type = "t3.micro"

  network_interfaces {
    delete_on_termination = true
    security_groups = [
      data.aws_security_group.sg_ssh.id, data.aws_security_group.sg_http.id
    ]
  }

  placement {
    availability_zone = "eu-west-1"
  }

  user_data = filebase64("${path.module}/script_green.sh")
}
resource "aws_autoscaling_group" "asg_blue" {
  name                = var.asg_blue
  max_size            = 2
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = data.aws_subnets.subnets_public.ids
  target_group_arns = [
    aws_lb_target_group.tg_blue.arn
  ]
  launch_template {
    id      = aws_launch_template.alt_blue.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_group" "asg_green" {
  name                = var.asg_green
  max_size            = 2
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = data.aws_subnets.subnets_public.ids
  target_group_arns = [
    aws_lb_target_group.tg_green.arn
  ]
  launch_template {
    id      = aws_launch_template.alt_blue.id
    version = "$Latest"
  }
}
resource "aws_lb" "load_balancer" {
  name               = var.loadbalancer
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.sg_lb_http.id]
  subnets            = data.aws_subnets.subnets_public.ids
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.tg_blue.arn
        weight = var.blue_weight
      }
      target_group {
        arn    = aws_lb_target_group.tg_green.arn
        weight = var.green_weight
      }
    }
  }
}

resource "aws_lb_target_group" "tg_blue" {
  name     = var.tg_blue
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group" "tg_green" {
  name     = var.tg_green
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}