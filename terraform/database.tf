resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  description = "Private subnets for the Nova Retail database"

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}