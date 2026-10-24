resource "aws_security_group" "k8s_sg_control" {
  name = "k8s-sg-control"
  description = "this is security group for control plane"
  vpc_id = aws_vpc.microapp.id
}

#for workernodes
resource "aws_security_group" "k8s_sg_worker" {
  name = "k8s-sg-worker"
  description = "this is security group for worker nodes"
  vpc_id = aws_vpc.microapp.id
}

#control plane security groups
resource "aws_vpc_security_group_ingress_rule" "worker_to_api" {
  security_group_id            = aws_security_group.k8s_sg_control.id
  referenced_security_group_id = aws_security_group.k8s_sg_worker.id

  from_port   = 6443
  to_port     = 6443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_rule" {
  security_group_id            = aws_security_group.k8s_sg_control.id
  referenced_security_group_id = aws_security_group.k8s_sg_control.id
  from_port   = 2379
  to_port     = 2380
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_to_api" {
  security_group_id            = aws_security_group.k8s_sg_control.id
  referenced_security_group_id = aws_security_group.ec2_sg.id

  from_port   = 6443
  to_port     = 6443
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "bastion_to_control" {
  security_group_id            = aws_security_group.k8s_sg_control.id
  referenced_security_group_id = aws_security_group.ec2_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  security_group_id = aws_security_group.k8s_sg_control.id
  from_port = 0
  to_port = 0
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

#worker security groupes rules

resource "aws_vpc_security_group_ingress_rule" "control_plane_to_worker" {
  security_group_id = aws_security_group.k8s_sg_worker.id
  referenced_security_group_id = aws_security_group.k8s_sg_control.id
  from_port = 10250
  to_port = 10250
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "load_balancer" {
  security_group_id            = aws_security_group.k8s_sg_worker.id
  referenced_security_group_id = aws_security_group.lb_sg.id

  from_port   = 30505
  to_port     = 30505
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "bastion_to_worker" {
  security_group_id = aws_security_group.k8s_sg_worker.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "worker_egrees_rule" {
  security_group_id = aws_security_group.k8s_sg_worker.id
  from_port = 0
  to_port = 0
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "worker_to_worker" {
  security_group_id            = aws_security_group.k8s_sg_worker.id
  referenced_security_group_id = aws_security_group.k8s_sg_worker.id

  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1
}


# Control plane -> Worker: Flannel VXLAN
resource "aws_vpc_security_group_ingress_rule" "control_to_worker_flannel" {
  security_group_id            = aws_security_group.k8s_sg_worker.id
  referenced_security_group_id = aws_security_group.k8s_sg_control.id

  from_port   = 8472
  to_port     = 8472
  ip_protocol = "udp"
}

# Worker -> Control plane: Flannel VXLAN
resource "aws_vpc_security_group_ingress_rule" "worker_to_control_flannel" {
  security_group_id            = aws_security_group.k8s_sg_control.id
  referenced_security_group_id = aws_security_group.k8s_sg_worker.id

  from_port   = 8472
  to_port     = 8472
  ip_protocol = "udp"
}

