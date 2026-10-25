resource "aws_instance" "worker" {
  subnet_id = aws_subnet.pvt_b.id
  instance_type = var.aws_instance_type
  ami = var.ami_id
  vpc_security_group_ids = [ aws_security_group.k8s_cluster_sg.id ]
  associate_public_ip_address=false
  key_name = aws_key_pair.instance_key_pair.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_instance" "control_plane" {
  subnet_id = aws_subnet.pvt_a.id
  instance_type = var.aws_instance_type
  ami = var.ami_id
  vpc_security_group_ids = [ aws_security_group.k8s_cluster_sg.id]
  associate_public_ip_address=false
  key_name = aws_key_pair.instance_key_pair.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_instance" "bastion_host" {
  subnet_id = aws_subnet.public_a.id
  instance_type = "t3.small"
  ami = var.ami_id
  vpc_security_group_ids = [ aws_security_group.bastion_sg.id]
  associate_public_ip_address=true
  key_name = aws_key_pair.instance_key_pair.key_name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_key_pair" "instance_key_pair" {
  key_name = "mykey"
  public_key = file("mykey.pub")
}
