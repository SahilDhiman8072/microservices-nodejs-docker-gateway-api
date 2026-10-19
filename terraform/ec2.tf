resource "aws_instance" "app_ec2_a" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = "t3.micro"
  subnet_id = aws_subnet.pvt_sub_a.id
  associate_public_ip_address= true
  vpc_security_group_ids=[aws_security_group.ec2_sg.id]
  ami = ""
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}


resource "aws_instance" "app_ec2_b" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = "t3.micro"
  subnet_id = aws_subnet.pvt_sub_b.id
  associate_public_ip_address= true
  vpc_security_group_ids=[aws_security_group.ec2_sg.id]
  ami = ""
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}


resource "aws_key_pair" "ec2_key_pair" {
  key_name = "microapp"
  public_key = file("microapp.pub")
}

resource "aws_security_group" "ec2_sg" {
  name = "microapp-sg"
  description = "allow only traffic from load balancer"
  vpc_id = aws_vpc.microapp.id
  ingress {
    from_port = 30505
    to_port = 30505
    protocol = "tcp"
    security_groups = [ aws_security_group.lb_sg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}