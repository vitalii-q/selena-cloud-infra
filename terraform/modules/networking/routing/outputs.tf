output "private_route_table_ids" {
  value = [
    aws_route_table.private_rt_1.id,
    aws_route_table.private_rt_2.id
  ]
}