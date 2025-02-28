output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.rds_instance.id
}

output "security_group_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds_sg.id
}
