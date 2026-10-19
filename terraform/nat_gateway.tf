
# 1. Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# 2. Create the NAT Gateway in the PUBLIC subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub_a.id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.microapp_igw
  ]
}

# 3. Add a default route to the PRIVATE route table
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.pvt_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
