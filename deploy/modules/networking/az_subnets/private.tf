resource "aws_subnet" "private_subnet" {
  availability_zone = var.az
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_block

  tags = {
    Name = "${var.username}-private-subnet-${var.az_suffix}"
    Tier = "private"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id                = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.username}-private-route-table-${var.az_suffix}"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet.id
}
