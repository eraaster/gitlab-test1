output "aurora_cluster_id" {
  description = "Aurora cluster ID"
  value       = aws_rds_cluster.aurora_cluster.id
}

output "aurora_endpoint" {
  description = "Aurora writer endpoint"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "aurora_security_group_id" {
  description = "Aurora DB security group ID"
  value       = aws_security_group.aurora_sg.id
}