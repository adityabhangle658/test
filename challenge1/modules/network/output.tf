output region {
  value       = var.region
}

output vpc_id {
  value       = aws_vpc.vpc.id
}

output mgt-subnet-id {
  value       = aws_subnet.management-subnet[0].id
}

output web-subnet-id {
  value       = aws_subnet.web-subnet.*.id
}

output app-subnet-id {
  value       = aws_subnet.application-subnet.*.id
}

output db-subnet-id {
  value       = aws_subnet.db-subnet.*.id
}

output web-sg {
  value       = aws_security_group.web-sg.id
}

output app-sg {
  value       = aws_security_group.app-sg.id
}

output db-sg {
  value       = aws_security_group.database-sg.id
}