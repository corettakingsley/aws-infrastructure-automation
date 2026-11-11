
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "nova-retail"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "AWS Availability Zones"
  type        = list(string)
  default     = ["af-south-1a", "af-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}


variable "db_name" {
  description = "Name of the Nova Retail database"
  type        = string
  default     = "novaretail"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "novaadmin"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}