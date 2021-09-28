
resource "aws_subnet" "private" {
  availability_zone = var.availability_zone
  vpc_id            = var.vpc.id
  cidr_block        = var.private_cidr_block

  tags = {
    Name = "${var.username}-private-subnet-${trimprefix(var.var.availability_zone, var.region)}"
  }
}

resource "aws_subnet" "public" {
  count = local.number_of_az

  availability_zone = var.az_names[count.index]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_address, local.public_subnet_newbits, count.index + local.number_of_az * 4)

  tags = {
    Name = "${var.username}-public-subnet-${trimprefix(var.az_names[count.index], var.region)}"
  }
}

resource "aws_eip" "eip_for_nat" {
  count = local.number_of_az

  vpc               = true

  tags = {
    Name = "${var.username}-eip-${trimprefix(var.az_names[count.index], var.region)}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = local.number_of_az

  allocation_id = aws_eip.eip_for_nat[count.index].id
  subnet_id     = resource.aws_subnet.public[count.index].id

  tags = {
    Name = "${var.username}-nat-public-${trimprefix(var.az_names[count.index], var.region)}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  count = local.number_of_az

  vpc_id            = aws_vpc.vpc.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
      carrier_gateway_id = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id = ""
      instance_id = ""
      ipv6_cidr_block = ""
      local_gateway_id = ""
      nat_gateway_id = ""
      network_interface_id = ""
      transit_gateway_id = ""
      vpc_endpoint_id = ""
      vpc_peering_connection_id = ""
    }
  ]
  tags = {
    Name = "${var.username}-public-route-table-${trimprefix(var.az_names[count.index], var.region)}"
  }
}

resource "aws_route_table_association" "public" {
  count = local.number_of_az

  subnet_id       = aws_subnet.public[count.index].id
  route_table_id  = aws_route_table.public[count.index].id
}


resource "aws_route_table" "private" {
  count = local.number_of_az

  vpc_id            = aws_vpc.vpc.id
  route = [{
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat[count.index].id

    network_interface_id = ""
    transit_gateway_id = ""
    vpc_endpoint_id = ""
    vpc_peering_connection_id = ""
    gateway_id = ""
    carrier_gateway_id = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id = ""
    instance_id = ""
    ipv6_cidr_block = ""
    local_gateway_id = ""
  }]

  tags = {
    Name = "${var.username}-private-route-table-${trimprefix(var.az_names[count.index], var.region)}"
  }
}

resource "aws_route_table_association" "private" {
  count = local.number_of_az

  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private[count.index].id
}
