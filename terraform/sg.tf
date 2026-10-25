
# Kubernetes cluster security group
resource "aws_security_group" "k8s_cluster_sg" {
  name        = "kubernetes-sg"
  description = "Security group for Kubernetes nodes"
  vpc_id      = aws_vpc.microapp_vpc.id
}

# SSH to Kubernetes nodes only from the bastion
resource "aws_vpc_security_group_ingress_rule" "k8s_ssh" {
  security_group_id            = aws_security_group.k8s_cluster_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

# Allow communication between nodes in this cluster
resource "aws_vpc_security_group_ingress_rule" "cluster_rule" {
  security_group_id            = aws_security_group.k8s_cluster_sg.id
  referenced_security_group_id = aws_security_group.k8s_cluster_sg.id
  ip_protocol                  = "-1"
}

# Kubernetes nodes outbound traffic
resource "aws_vpc_security_group_egress_rule" "cluster_outbound" {
  security_group_id = aws_security_group.k8s_cluster_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_lb_traffic" {
  security_group_id = aws_security_group.k8s_cluster_sg.id
  referenced_security_group_id = aws_security_group.lb_sg.id
  from_port = 30505
  to_port = 30505
  ip_protocol = "tcp"
}


# Bastion security group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.microapp_vpc.id
}

# SSH to bastion - restrict to your public IP
resource "aws_vpc_security_group_ingress_rule" "bastion_sgrule" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Bastion outbound traffic
resource "aws_vpc_security_group_egress_rule" "bastion_outbound" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
