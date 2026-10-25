resource "aws_lb_target_group" "microapp_tg" {
  target_type = "instance"
  vpc_id = aws_vpc.microapp_vpc.id
  port = "30505"
  protocol = "HTTP"

   health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/health"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "A" {
  target_group_arn = aws_lb_target_group.microapp_tg.id
  target_id = aws_instance.worker.id
  port = "30505"
}

