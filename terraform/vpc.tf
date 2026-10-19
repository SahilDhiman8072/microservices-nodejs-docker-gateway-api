resource "aws_vpc" "microapp" {
  cidr_block = "192.168.10.0/24"
}

resource "aws_subnet" "public_sub_a" {
  #for elastic load balancer -1
  vpc_id = aws_vpc.microapp.id
  cidr_block = "192.168.10.0/28"
}
resource "aws_subnet" "public_sub_b" {
  #for elastic load balancer -2
  vpc_id = aws_vpc.microapp.id
  cidr_block = "192.168.10.16/28"
}

#private subnet A for application
resource "aws_subnet" "pvt_sub_a" {
  vpc_id = aws_vpc.microapp.id
  cidr_block = "192.168.10.32/28"
}

#private subnet B for application
resource "aws_subnet" "pvt_sub_b" {
  vpc_id = aws_vpc.microapp.id
  cidr_block = "192.168.10.48/28"
}

# public route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.microapp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.microapp_igw.id
  }
}

# private route table
resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.microapp.id
}


# internet gateway
resource "aws_internet_gateway" "microapp_igw" {
  vpc_id = aws_vpc.microapp.id
}

# route table association with subnet public A
resource "aws_route_table_association" "public_rt_ass_a" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_sub_a.id
}

# route table association with subnet public B
resource "aws_route_table_association" "public_rt_ass_b" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_sub_b.id
}

#route table association with subnet pvt A
resource "aws_route_table_association" "pvt-rt-ass-a" {
  subnet_id = aws_subnet.pvt_sub_a.id
  route_table_id = aws_route_table.pvt_rt.id
}

#route table association with subnet pvt B
resource "aws_route_table_association" "pvt-rt-ass-b" {
  subnet_id = aws_subnet.pvt_sub_b.id
  route_table_id = aws_route_table.pvt_rt.id
}

# vpc flow logs
resource "aws_flow_log" "microapp_flow_log" {
  vpc_id               = aws_vpc.microapp.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
}
