resource "aws_subnet" "public_subnet" {
  availability_zone = var.az
  vpc_id            = var.vpc_id
  cidr_block        = var.public_cidr_block

  tags = {
    Name = "${var.username}-public-subnet-${var.az_suffix}"
    Tier = "public"
  }
}

resource "aws_eip" "eip_for_nat" {
  vpc   = true

  tags = {
    Name = "${var.username}-eip-${var.az_suffix}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_for_nat.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.username}-nat-${var.az_suffix}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id                = var.internet_gateway_id
  }

  tags = {
    Name = "${var.username}-public-route-table-${var.az_suffix}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}
