output "vpc_id" {
  description = "ID of the Nova Retail VPC"
  value       = aws_vpc.main.id
}

output "load_balancer_dns" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "database_endpoint" {
  description = "Private endpoint of the MySQL database"
  value       = aws_db_instance.main.endpoint
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}
