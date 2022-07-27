output "vpc_id" {
  value = aws_vpc.cheguei_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.cheguei_subnets[*].id
}