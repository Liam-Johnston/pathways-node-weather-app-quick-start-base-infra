output "nat_gw_id" {
  value = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].id : null
}
