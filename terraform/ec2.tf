resource "aws_instance" "app_ec2_a" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.pvt_sub_a.id
  associate_public_ip_address= false
  vpc_security_group_ids=[ aws_security_group.k8s_sg_worker.id]
  ami = var.ami_id
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}
# kubernetes control plane
resource "aws_instance" "control-plane" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_control_place.id
  associate_public_ip_address= false
  vpc_security_group_ids=[ aws_security_group.k8s_sg_control.id]
  ami = var.ami_id
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}


resource "aws_instance" "app_ec2_b" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.pvt_sub_b.id
  associate_public_ip_address= false
  vpc_security_group_ids=[ aws_security_group.k8s_sg_worker.id]
  ami = var.ami_id
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}

resource "aws_instance" "bastion_host" {
  key_name = aws_key_pair.ec2_key_pair.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_sub_a.id
  associate_public_ip_address= true
  vpc_security_group_ids=[aws_security_group.ec2_sg.id]
  ami = var.ami_id
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
  description = "allow only ssh traffic from anywhere"
  vpc_id = aws_vpc.microapp.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}