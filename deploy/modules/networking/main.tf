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

module "subnets" {
  count       = length(var.az_names)
  source = "./az_subnets"

  username    = var.username
  az          = var.az_names[count.index]
  az_suffix   = trimprefix(var.az_names[count.index], var.region)

  vpc_id              = aws_vpc.vpc.id
  internet_gateway_id =  aws_internet_gateway.igw.id

  private_cidr_block = cidrsubnet(var.cidr_address, local.private_subnet_newbits, count.index)
  public_cidr_block = cidrsubnet(var.cidr_address, local.public_subnet_newbits, count.index + length(var.az_names) * 4)
}
