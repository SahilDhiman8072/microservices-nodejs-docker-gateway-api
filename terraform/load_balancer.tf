resource "aws_lb" "microapp_bl" {
  name = "microapp-load"
  load_balancer_type = "application"
  internal = false
  security_groups = [ aws_security_group.lb_sg.id ]
  subnets = [aws_subnet.public_sub_a.id,aws_subnet.public_sub_b.id]
  tags = {
    environment="production"
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.microapp.id
  name="microapp-load-balancer"
  description = "allow http and https treaffic from internet"
  ingress {
    from_port = 80 
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 443
    to_port = 443 
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.microapp_bl.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.microapp_tg.arn
  }
}