resource "aws_vpc" "vpc" {
  cidr_block  = var.cidr_address

  tags        = {
    Name = "${var.username}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.username}-igw"
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = data.aws_vpc_endpoint_service.s3.service_name

  tags = {
    Name = "${var.username}-s3-vpc-endpoint"
  }
}

module "public_subnets" {
  count       = length(var.az_names)
  source      = "./subnet"

  username    = var.username
  az          = var.az_names[count.index]
  az_suffix   = trimprefix(var.az_names[count.index], var.region)
  vpc_id      = aws_vpc.vpc.id

  cidr_block  = cidrsubnet(var.cidr_address, local.public_subnet_newbits, count.index + local.number_of_az * 4)
  subnet_type = "public"
  rt_gw_id    = aws_internet_gateway.igw.id
}

module "private_subnets" {
  count   = length(var.az_names)
  source  = "./subnet"

  username      = var.username
  az            = var.az_names[count.index]
  az_suffix     = trimprefix(var.az_names[count.index], var.region)
  vpc_id        = aws_vpc.vpc.id

  cidr_block    = cidrsubnet(var.cidr_address, local.private_subnet_newbits, count.index)
  subnet_type   = "private"
  rt_nat_gw_id  = module.public_subnets[count.index].nat_gw_id
}
