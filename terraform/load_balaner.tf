resource "aws_lb" "microapp_lb" {
  name = "microapp-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [ aws_subnet.public_a.id, aws_subnet.public_b.id ]
  security_groups = [ aws_security_group.lb_sg.id ]
}
resource "aws_security_group" "lb_sg" {
  name = "microapp-lb"
  vpc_id = aws_vpc.microapp_vpc.id
  description = "allow http"
  ingress {
    from_port = 80
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#  HTTP listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.microapp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.microapp_tg.arn
  }
}

