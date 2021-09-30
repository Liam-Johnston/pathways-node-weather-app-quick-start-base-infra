locals {
# This is a programatic way of determining the minimum number of additional bits in which to extend
# the prefix taking into account the number of avaliability zones provided.
  private_subnet_newbits = max(ceil(log(length(var.az_names), 2)), 2)

  public_subnet_newbits = local.private_subnet_newbits + 2
}
