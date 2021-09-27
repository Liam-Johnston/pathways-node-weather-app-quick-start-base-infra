locals {
  aws_service_endpoint = "com.amazonaws.${var.region}"

  number_of_az = length(var.az_names)

  private_subnet_newbits = max(ceil(log(local.number_of_az, 2)), 2)

  public_subnet_newbits = local.private_subnet_newbits + 2
}
