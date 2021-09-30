resource "aws_subnet" "this" {
  availability_zone = var.az
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block

  tags = {
    Name = "${var.username}-${var.subnet_type}-subnet-${var.az_suffix}"
  }
}

resource "aws_eip" "eip_for_nat" {
  count = var.subnet_type == "public" ? 1 : 0
  vpc   = true

  tags = {
    Name = "${var.username}-eip-${var.az_suffix}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.subnet_type == "public" ? 1 : 0
  allocation_id = aws_eip.eip_for_nat[count.index].id
  subnet_id     = resource.aws_subnet.this.id

  tags = {
    Name = "${var.username}-nat-${var.subnet_type}-${var.az_suffix}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id            = var.vpc_id

  route {
      cidr_block      = "0.0.0.0/0"
      gateway_id      = var.rt_gw_id
      nat_gateway_id  = var.rt_nat_gw_id
    }

  tags = {
    Name = "${var.username}-${var.subnet_type}-route-table-${var.az_suffix}"
  }
}
