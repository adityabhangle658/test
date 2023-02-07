# Target Group Creation
resource "aws_lb_target_group" "tg" {
  name        = "${var.prefix}-TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

# Target Group Attachment with Instance
resource "aws_alb_target_group_attachment" "tg-attach" {
  count            = var.total_instance
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(aws_instance.instance.*.id, count.index)
}

# Application Load balancer
resource "aws_lb" "lb" {
  name               = "${var.prefix}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.vpc_security_group_ids]
  subnets            = var.subnet_ids.*.id
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

# Listener Rule
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }
}