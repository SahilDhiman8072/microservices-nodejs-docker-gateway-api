resource "aws_vpc" "microapp_vpc" {
  cidr_block = "192.168.1.0/24"
  tags = {
    Name="microapp-vpc"
  }
}

# public subnet A
resource "aws_subnet" "public_a" {
  cidr_block = "192.168.1.0/28"
  vpc_id = aws_vpc.microapp_vpc.id
  availability_zone = "ap-south-1a"
}

# public subnet B
resource "aws_subnet" "public_b" {
  cidr_block = "192.168.1.16/28"
  vpc_id = aws_vpc.microapp_vpc.id
  availability_zone = "ap-south-1b"
}
# pvt subnet A

resource "aws_subnet" "pvt_a" {
  cidr_block = "192.168.1.32/28"
  vpc_id = aws_vpc.microapp_vpc.id
  availability_zone = "ap-south-1a"
}

# pvt subnet B
resource "aws_subnet" "pvt_b" {
  cidr_block = "192.168.1.48/28"
  vpc_id = aws_vpc.microapp_vpc.id
  availability_zone = "ap-south-1b"
}

# public route table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.microapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.microapp_vpc.id
}

# pvt route table

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.microapp_vpc.id
}

# public route table association
resource "aws_route_table_association" "public_rt_A_ass" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_rt_B_ass" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_b.id
}
# private route table association
resource "aws_route_table_association" "pvt_rt_A_ass" {
  route_table_id = aws_route_table.pvt_rt.id
  subnet_id = aws_subnet.pvt_a.id
}

resource "aws_route_table_association" "pvt_rt_B_ass" {
  route_table_id = aws_route_table.pvt_rt.id
  subnet_id = aws_subnet.pvt_b.id
}