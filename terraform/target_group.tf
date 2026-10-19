resource "aws_lb_target_group" "microapp_tg" {
  name        = "microapp-target-group"
  port        = 30505
  protocol    = "HTTP"
  vpc_id      = aws_vpc.microapp.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    environment = "production"
  }
}

resource "aws_lb_target_group_attachment" "microapp_attachment_a" {
  target_group_arn = aws_lb_target_group.microapp_tg.arn
  target_id        = aws_instance.app_ec2_a.id
  port             = 30505
}

resource "aws_lb_target_group_attachment" "microapp_attachment_b" {
  target_group_arn = aws_lb_target_group.microapp_tg.arn
  target_id        = aws_instance.app_ec2_b.id
  port             = 30505
}