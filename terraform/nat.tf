
# 1. Allocate an Elastic IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "microapp-nat-eip"
  }
}

# 2. Create NAT Gateway in a public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "microapp-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# 3. Route private subnet traffic through NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.pvt_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
